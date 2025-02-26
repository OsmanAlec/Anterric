# Extends the CharacterBody3D class to create a custom 3D character with physics-based movement.
extends CharacterBody3D

# Constants for movement speed and the group name for ladybugs.
const SPEED: float = 5.0
const LADYBUG_GROUP: String = "Ladybugs"

# Exported variables to configure ladybug behavior in the Godot editor.
@export var detection_radius: float = 4.0  # Radius within which the ladybug detects the player.
@export var stopping_distance: float = 3.0  # Distance at which the ladybug stops moving toward the player.
@export var flying_height: float = 0.4  # Height at which the ladybug flies.
@export var ascent_speed: float = 0.5  # Speed at which the ladybug ascends to flying height.
@export var formation_spacing: float = 2.5  # Spacing between ladybugs in formation.
@export var formation_lag: float = 0.2  # Smoothing factor for formation movement (higher = smoother).
@export var avoidance_weight: float = 0.8  # Strength of avoidance behavior between ladybugs.
@export var avoidance_radius: float = 1.2  # Distance at which ladybugs start avoiding each other.
@export var max_acceleration: float = 10.0  # Maximum change in velocity per second.
@export var ballofgust_scene: PackedScene  # Scene for the projectile (Ball of Gust).

# References to nodes and variables for animation and state management.
@onready var anim_tree = get_node("AnimationTree")  # AnimationTree for controlling animations.
@onready var marker = $ProjectileSpawn  # Marker node for spawning projectiles.

# State variables for flying, attacking, and formation behavior.
var isFlying: bool = false  # Whether the ladybug is flying.
var flight_progress: float = 0.0  # Progress of the ascent to flying height.
var canAttack = true  # Whether the ladybug can attack.
var formation_index: int = -1  # Index of this ladybug in the formation.
var current_velocity: Vector3 = Vector3.ZERO  # Current velocity of the ladybug.
var target_position: Vector3 = Vector3.ZERO  # Target position for movement.
var formation_target_positions: Array = []  # Array of target positions for the formation.

# Timer variables for forced attacks.
var attack_timer_elapsed: float = 0.0  # Time elapsed since the last forced attack.
const FORCED_ATTACK_TIME: float = 5.0  # Time interval for forced attacks.

# Called when the node enters the scene tree.
func _ready() -> void:
	
	
	add_to_group(LADYBUG_GROUP)  # Add this ladybug to the ladybug group.
	update_formation_index()  # Update its formation index.
	formation_lag *= (1.0 + randf_range(-0.1, 0.1))  # Add slight randomness to formation lag.

# Updates the formation index based on the ladybug's position in the group.
func update_formation_index() -> void:
	var ladybugs = get_tree().get_nodes_in_group(LADYBUG_GROUP)  # Get all ladybugs in the group.
	formation_index = ladybugs.find(self)  # Find this ladybug's index in the group.

# Called every physics frame to handle movement and behavior.
func _physics_process(delta: float) -> void:
	var player = get_tree().get_first_node_in_group("Player")  # Get the player node.
	if not player:  # If there's no player, stop moving.
		velocity = Vector3.ZERO
		return
		
	var to_player = player.global_position - global_position  # Vector to the player.
	var distance = to_player.length()  # Distance to the player.
	var direction = to_player.normalized()  # Normalized direction to the player.

	# Start flying if the player is within detection radius and not already flying.
	if distance < detection_radius and not isFlying:
		isFlying = true
		anim_tree.get("parameters/playback").travel("takeoff")  # Play takeoff animation.
		anim_tree.set("parameters/flying idle/BlendSpace1D/blend_position", direction.x)  # Set animation blend.

	# Handle flying behavior.
	if isFlying:
		flight_progress = min(flight_progress + ascent_speed * delta, 1.0)  # Update ascent progress.
		global_position.y = lerp(global_position.y, flying_height, flight_progress * delta * 2.0)  # Smoothly ascend.
		
		# Handle attack or movement based on distance to the player.
		if distance <= stopping_distance:
			handle_attack_state(player, direction)  # Attack if close enough.
		else:
			handle_movement_state(player, delta)  # Move toward the player otherwise.
	else:
		velocity = Vector3.ZERO  # Stop moving if not flying.
		anim_tree.get("parameters/playback").travel("ground idle")  # Play ground idle animation.
		anim_tree.set("parameters/flying idle/BlendSpace1D/blend_position", direction.x)  # Set animation blend.
	
	move_and_slide()  # Apply movement using Godot's physics engine.

# Handles the attack state when the ladybug is close to the player.
func handle_attack_state(player, direction) -> void:
	velocity = Vector3.ZERO  # Stop moving.
	attack_timer_elapsed = 0.0  # Reset forced attack timer.
	if canAttack:
		$attack_timer.start()  # Start attack timer.
		canAttack = false  # Prevent further attacks until the timer ends.
		anim_tree.get("parameters/playback").travel("attack")  # Play attack animation.
		anim_tree.set("parameters/attack/BlendSpace1D/blend_position", direction.x)  # Set animation blend.
		await get_tree().create_timer(0.6).timeout  # Wait for 0.6 seconds.
		shoot_ball_of_gust(player)  # Shoot a projectile.
	else:
		anim_tree.get("parameters/playback").travel("flying idle")  # Play flying idle animation.
		anim_tree.set("parameters/flying idle/BlendSpace1D/blend_position", direction.x)  # Set animation blend.

# Handles movement state when the ladybug is flying toward the player.
func handle_movement_state(player, delta) -> void:
	update_formation_index()  # Update formation index.
	update_formation_positions(player)  # Update target positions for the formation.
	
	# Determine target position based on formation index.
	if formation_index >= formation_target_positions.size():
		target_position = player.global_position + Vector3(randf_range(-2, 2), 0.2, randf_range(-2, 2))  # Random position if out of bounds.
	else:
		target_position = formation_target_positions[formation_index]  # Use formation position.
	
	var to_formation = target_position - global_position  # Vector to the target position.
	var distance_to_formation = to_formation.length()  # Distance to the target position.
	var adaptive_speed = SPEED * distance_to_formation if distance_to_formation < 1.0 else SPEED  # Adjust speed based on distance.

	var desired_velocity = to_formation.normalized() * adaptive_speed  # Desired velocity toward the target.
	desired_velocity += calculate_avoidance_force()  # Add avoidance force to avoid other ladybugs.
	
	var acceleration = (desired_velocity - current_velocity) / delta  # Calculate acceleration.
	if acceleration.length() > max_acceleration:
		acceleration = acceleration.normalized() * max_acceleration  # Limit acceleration.
	current_velocity += acceleration * delta  # Update current velocity.
	
	var smoothing_factor = clamp(delta / formation_lag, 0.0, 1.0)  # Smoothing factor for movement.
	velocity = velocity.lerp(current_velocity, smoothing_factor)  # Smoothly update velocity.
	if velocity.length() > SPEED:
		velocity = velocity.normalized() * SPEED  # Limit velocity to max speed.
	
	anim_tree.get("parameters/playback").travel("flying moving")  # Play flying moving animation.
	if velocity.length() > 0.1:
		anim_tree.set("parameters/flying moving/BlendSpace2D/blend_position", Vector2(velocity.normalized().x, velocity.normalized().z))  # Set animation blend.
	
	# Increment forced attack timer.
	attack_timer_elapsed += delta
	if attack_timer_elapsed >= FORCED_ATTACK_TIME:
		# Force an attack if the timer exceeds the threshold.
		handle_attack_state(player, (player.global_position - global_position).normalized())
		attack_timer_elapsed = 0.0

# Calculates avoidance force to prevent ladybugs from colliding with each other.
func calculate_avoidance_force() -> Vector3:
	var avoidance = Vector3.ZERO
	var ladybugs = get_tree().get_nodes_in_group(LADYBUG_GROUP)  # Get all ladybugs.
	for ladybug in ladybugs:
		if ladybug == self or not is_instance_valid(ladybug):  # Skip self and invalid ladybugs.
			continue
		var to_other = global_position - ladybug.global_position  # Vector to another ladybug.
		var distance = to_other.length()  # Distance to the other ladybug.
		if distance < avoidance_radius:  # If too close, calculate repulsion force.
			var repulsion_strength = (avoidance_radius - distance) / avoidance_radius
			avoidance += to_other.normalized() * repulsion_strength * avoidance_weight
	return avoidance

# Updates target positions for the formation based on the player's position.
func update_formation_positions(player) -> void:
	var ladybugs = get_tree().get_nodes_in_group(LADYBUG_GROUP)  # Get all ladybugs.
	var ladybug_count = ladybugs.size()  # Number of ladybugs.
	if ladybug_count == 0:
		return
		
	var player_forward = -player.global_transform.basis.z.normalized()  # Player's forward direction.
	var player_right = player.global_transform.basis.x.normalized()  # Player's right direction.
	
	formation_target_positions = []  # Reset target positions.
	
	# Calculate formation positions based on the number of ladybugs.
	if ladybug_count == 1:
		formation_target_positions.append(player.global_position + (-player_forward * 2.0) + Vector3(0, 0.2, 0))  # Single ladybug position.
	elif ladybug_count == 2:
		formation_target_positions.append(player.global_position + (player_right * formation_spacing) + Vector3(0, 0.2, 0))  # Two ladybug positions.
		formation_target_positions.append(player.global_position + (-player_right * formation_spacing) + Vector3(0, 0.2, 0))
	else:
		var angle_spread = deg_to_rad(120.0)  # Spread angle for multiple ladybugs.
		var start_angle = -angle_spread / 2.0  # Starting angle.
		var angle_step = angle_spread / (ladybug_count - 1)  # Angle step between ladybugs.
		var radius = 4.0  # Formation radius.
		for i in range(ladybug_count):
			var my_angle = start_angle + (i * angle_step)  # Calculate angle for this ladybug.
			var offset = player_forward.rotated(Vector3.UP, my_angle) * -radius  # Calculate offset.
			formation_target_positions.append(player.global_position + offset + Vector3(0, 0.2, 0))  # Add target position.
	
	apply_minimum_distance_constraint()  # Ensure minimum spacing between ladybugs.

# Ensures minimum spacing between ladybugs in the formation.
func apply_minimum_distance_constraint() -> void:
	if formation_target_positions.size() < 2:
		return
	var min_distance = formation_spacing * 0.8  # Minimum allowed distance.
	var positions = formation_target_positions.duplicate()  # Copy of target positions.
	var max_iterations = 10  # Maximum iterations for adjustment.
	for iteration in range(max_iterations):
		var any_adjustment = false
		for i in range(positions.size()):
			for j in range(i + 1, positions.size()):
				var direction = positions[j] - positions[i]  # Vector between two positions.
				var distance = direction.length()  # Distance between two positions.
				if distance < min_distance:  # If too close, adjust positions.
					var adjustment = direction.normalized() * (min_distance - distance) * 0.5
					positions[i] -= adjustment
					positions[j] += adjustment
					any_adjustment = true
		if not any_adjustment:
			break
	formation_target_positions = positions  # Update target positions.

# Called when the attack timer ends, allowing the ladybug to attack again.
func _on_attack_timer_timeout() -> void:
	canAttack = true

# Shoots a projectile (Ball of Gust) toward the player.
func shoot_ball_of_gust(player) -> void:
	if player and ballofgust_scene and is_instance_valid(player):
		
		var projectile = ballofgust_scene.instantiate() as RigidBody3D  # Instantiate the projectile.
		get_tree().current_scene.add_child(projectile)  # Add it to the scene.
		projectile.global_position = marker.global_position  # Set its position.
		projectile.set_direction(player.global_position)  # Set its direction toward the player.
	

signal died  # Signal to notify when an enemy dies

func die():
	print("Enemy died!")
	died.emit()  # Notify the Enemies node
	queue_free()  # Remove the enemy from the scene

# Called when the ladybug's health is depleted.
func _on_health_health_depleted() -> void:
	remove_from_group(LADYBUG_GROUP)  # Remove from the ladybug group.
	var ladybugs = get_tree().get_nodes_in_group(LADYBUG_GROUP)  # Get remaining ladybugs.
	
	
	died.emit()  # Notify the parent node
	print("enemiy dead")
	
	for bug in ladybugs:
		if is_instance_valid(bug):
			bug.update_formation_index()  # Update their formation indices.
	queue_free()  # Remove this ladybug from the scene.
	
	
func set_projectile_scene(scene: PackedScene):
	ballofgust_scene = scene
	



	
