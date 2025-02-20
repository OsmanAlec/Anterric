extends CharacterBody3D

const SPEED: float = 5.0
const LADYBUG_GROUP: String = "Ladybugs"

@export var detection_radius: float = 4.0
@export var stopping_distance: float = 3.0
@export var flying_height: float = 0.4
@export var ascent_speed: float = 0.5
@export var formation_spacing: float = 2.5
@export var formation_lag: float = 0.2  # Higher value = more smoothing
@export var avoidance_weight: float = 0.8  # How strongly ladybugs avoid each other
@export var avoidance_radius: float = 1.2  # Distance at which avoidance begins
@export var max_acceleration: float = 10.0  # Limits change in velocity per second
@export var ballofgust_scene: PackedScene

@onready var anim_tree = get_node("AnimationTree")
@onready var marker = $ProjectileSpawn

var isFlying: bool = false
var flight_progress: float = 0.0
var canAttack = true
var formation_index: int = -1
var current_velocity: Vector3 = Vector3.ZERO
var target_position: Vector3 = Vector3.ZERO
var formation_target_positions = {}

func _ready() -> void:
	add_to_group(LADYBUG_GROUP)
	
	# Assign formation index when added to the scene
	update_formation_index()
	
	# Randimisation to initial parameters to prevent synchronized movement
	formation_lag = formation_lag * (1.0 + randf_range(-0.1, 0.1))

# Updates the formation index based on current group membership
func update_formation_index() -> void:
	var ladybugs = get_tree().get_nodes_in_group(LADYBUG_GROUP)
	formation_index = ladybugs.find(self)

func _physics_process(delta: float) -> void:
	var player = get_tree().get_first_node_in_group("Player")
	if not player:
		velocity = Vector3.ZERO
		return
		
	var to_player = player.global_position - global_position
	var distance = to_player.length()
	var direction = to_player.normalized()

	# Handle flying state transition
	if distance < detection_radius and not isFlying:
		isFlying = true
		anim_tree.get("parameters/playback").travel("takeoff")
		anim_tree.set("parameters/flying idle/BlendSpace1D/blend_position", direction.x)

	if isFlying:
		# Smooth flying height transition
		flight_progress = min(flight_progress + ascent_speed * delta, 1.0)
		global_position.y = lerp(global_position.y, flying_height, flight_progress * delta * 2.0)
		
		if distance <= stopping_distance:
			handle_attack_state(player, direction)
		else:
			handle_movement_state(player, delta)
	else:
		# Idle behavior
		velocity = Vector3.ZERO
		anim_tree.get("parameters/playback").travel("ground idle")
		anim_tree.set("parameters/flying idle/BlendSpace1D/blend_position", direction.x)
	
	move_and_slide()

func handle_attack_state(player, direction) -> void:
	velocity = Vector3.ZERO
	
	if canAttack:
		$attack_timer.start()
		canAttack = false
		anim_tree.get("parameters/playback").travel("attack")
		anim_tree.set("parameters/attack/BlendSpace1D/blend_position", direction.x)
		await get_tree().create_timer(0.6).timeout
		shoot_ball_of_gust(player)
	else:
		anim_tree.get("parameters/playback").travel("flying idle")
		anim_tree.set("parameters/flying idle/BlendSpace1D/blend_position", direction.x)

func handle_movement_state(player, delta) -> void:
	# Ensure formation index is current
	update_formation_index()
	
	# Calculate all formation positions first
	update_formation_positions(player)
	
	# Get this ladybug's target position (with safety check)
	if not formation_target_positions.has(formation_index):
		# Emergency fallback if position not found
		target_position = player.global_position + Vector3(randf_range(-2, 2), 0.2, randf_range(-2, 2))
	else:
		target_position = formation_target_positions[formation_index]
	
	# Calculate base movement towards formation position
	var to_formation = target_position - global_position
	var distance_to_formation = to_formation.length()
	
	# Adaptive speed based on distance
	var adaptive_speed = SPEED
	if distance_to_formation < 1.0:
		adaptive_speed = SPEED * distance_to_formation
	
	# Base desired velocity toward formation position
	var desired_velocity = to_formation.normalized() * adaptive_speed
	
	# Add avoidance forces from other ladybugs
	var avoidance_force = calculate_avoidance_force()
	desired_velocity += avoidance_force
	
	# Limit acceleration for smoother movement
	var acceleration = (desired_velocity - current_velocity) / delta
	if acceleration.length() > max_acceleration:
		acceleration = acceleration.normalized() * max_acceleration
	
	# Apply acceleration to current velocity
	current_velocity += acceleration * delta
	
	# Apply smoothing using exponential smoothing
	var smoothing_factor = clamp(delta / formation_lag, 0.0, 1.0)
	velocity = velocity.lerp(current_velocity, smoothing_factor)
	
	# Limit maximum speed
	if velocity.length() > SPEED:
		velocity = velocity.normalized() * SPEED
	
	# Update animation
	anim_tree.get("parameters/playback").travel("flying moving")
	if velocity.length() > 0.1:
		anim_tree.set("parameters/flying moving/BlendSpace2D/blend_position", Vector2(velocity.normalized().x, velocity.normalized().z))

func calculate_avoidance_force() -> Vector3:
	var avoidance = Vector3.ZERO
	var ladybugs = get_tree().get_nodes_in_group(LADYBUG_GROUP)
	
	for ladybug in ladybugs:
		if ladybug == self or not is_instance_valid(ladybug):
			continue
			
		var to_other = global_position - ladybug.global_position
		var distance = to_other.length()
		
		if distance < avoidance_radius:
			# Calculate repulsion force (stronger as distance decreases)
			var repulsion_strength = (avoidance_radius - distance) / avoidance_radius
			var repulsion = to_other.normalized() * repulsion_strength * avoidance_weight
			avoidance += repulsion
	
	return avoidance

func update_formation_positions(player) -> void:
	var ladybugs = get_tree().get_nodes_in_group(LADYBUG_GROUP)
	var ladybug_count = ladybugs.size()
	
	# Safety check
	if ladybug_count == 0:
		return
		
	var player_forward = -player.global_transform.basis.z.normalized()
	var player_right = player.global_transform.basis.x.normalized()
	
	# Clear previous positions
	formation_target_positions.clear()
	
	# Assign indices to each active ladybug
	for i in range(ladybug_count):
		if is_instance_valid(ladybugs[i]):
			# Each ladybug needs a valid and unique index
			ladybugs[i].formation_index = i
	
	# Determine formation type based on ladybug count
	if ladybug_count == 1:
		# Single ladybug formation
		formation_target_positions[0] = player.global_position + (-player_forward * 2.0) + Vector3(0, 0.2, 0)
	elif ladybug_count == 2:
		# Two ladybug formation
		formation_target_positions[0] = player.global_position + (player_right * formation_spacing) + Vector3(0, 0.2, 0)
		formation_target_positions[1] = player.global_position + (-player_right * formation_spacing) + Vector3(0, 0.2, 0)
	else:
		# Arc formation for multiple ladybugs
		var angle_spread = deg_to_rad(120.0)
		var start_angle = -angle_spread / 2.0
		var angle_step = angle_spread / (ladybug_count - 1) if ladybug_count > 1 else 0
		var radius = 4.0  # Distance behind player
		
		for i in range(ladybug_count):
			var my_angle = start_angle + (i * angle_step)
			var offset = player_forward.rotated(Vector3.UP, my_angle) * -radius
			formation_target_positions[i] = player.global_position + offset + Vector3(0, 0.2, 0)
	
	# Apply Poisson disc sampling to ensure minimum distance between positions
	apply_minimum_distance_constraint()

func apply_minimum_distance_constraint() -> void:
	# Safety check - if no positions, just return
	if formation_target_positions.size() < 2:
		return
		
	var min_distance = formation_spacing * 0.8
	var positions = formation_target_positions.values()
	var max_iterations = 10
	
	# Iteratively adjust positions to maintain minimum distance
	for iteration in range(max_iterations):
		var any_adjustment = false
		
		for i in range(positions.size()):
			for j in range(i+1, positions.size()):
				var pos_i = positions[i]
				var pos_j = positions[j]
				var direction = pos_j - pos_i
				var distance = direction.length()
				
				if distance < min_distance:
					var adjustment = direction.normalized() * (min_distance - distance) * 0.5
					positions[i] -= adjustment
					positions[j] += adjustment
					any_adjustment = true
		
		if not any_adjustment:
			break
	
	# Update formation target positions with adjusted values
	var keys = formation_target_positions.keys()
	for i in range(keys.size()):
		if i < positions.size():  # Safety check
			formation_target_positions[keys[i]] = positions[i]

func _on_attack_timer_timeout() -> void:
	canAttack = true

func shoot_ball_of_gust(player) -> void:
	if player and ballofgust_scene and is_instance_valid(player):
		var projectile = ballofgust_scene.instantiate() as RigidBody3D
		get_tree().current_scene.add_child(projectile)  
		projectile.global_position = marker.global_position
		projectile.set_direction(player.global_position)

func _on_health_health_depleted() -> void:
	# Make sure to properly remove from group before queue_free
	# This ensures other ladybugs won't try to access this one
	remove_from_group(LADYBUG_GROUP)
	
	# Notify remaining ladybugs that the formation changed
	var ladybugs = get_tree().get_nodes_in_group(LADYBUG_GROUP)
	for bug in ladybugs:
		if is_instance_valid(bug):
			bug.update_formation_index()
			
	queue_free()
