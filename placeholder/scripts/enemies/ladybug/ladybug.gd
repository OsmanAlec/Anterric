extends CharacterBody3D

const SPEED: float = 5.0

@export var detection_radius: float = 4.0  # Detection range for flying
@export var stopping_distance: float = 3.0  # Maintain distance when following
@export var flying_height: float = 0.4  # Target height when flying
@export var ascent_speed: float = 0.5  # Speed of flying up
@export var ballofgust_scene: PackedScene  # Assign BallOfGust scene in the Inspector
@onready var marker = $ProjectileSpawn  # Spawn point for projectile

@onready var anim_tree = get_node("AnimationTree")

var isFlying: bool = false  # Tracks if ladybug is flying
var flight_progress: float = 0.0  # Smooth flight transition
var canAttack = true

func _physics_process(delta: float) -> void:
	var player =  get_tree().get_nodes_in_group("Player")[0]
	var direction : Vector3 = Vector3.ZERO
	
	if player:
		direction = (player.global_transform.origin - global_transform.origin).normalized()
		var distance = global_transform.origin.distance_to(player.global_transform.origin)

		# If the ant enters the detection radius, the ladybug takes off
		if distance < detection_radius and not isFlying:
			isFlying = true  # Enable flying mode
			anim_tree.get("parameters/playback").travel("takeoff")
			anim_tree.set("parameters/flying idle/BlendSpace1D/blend_position", direction.x) 

		if isFlying:
			# increase Y position to simulate flying using lerp
			flight_progress = min(flight_progress + ascent_speed * delta, 1.0)
			global_transform.origin.y = lerp(global_transform.origin.y, flying_height, flight_progress)
			
			# Follow player, but maintain stopping distance
			if distance > stopping_distance:
				velocity = velocity.lerp(direction * SPEED, delta * 5)
				anim_tree.get("parameters/playback").travel("flying moving")
				anim_tree.set("parameters/flying moving/BlendSpace2D/blend_position", Vector2(direction.x, direction.z)) 
			else:
				velocity = Vector3.ZERO  # Stop if too close
				if canAttack:
					$attack_timer.start()
					canAttack = false
					anim_tree.get("parameters/playback").travel("attack")
					anim_tree.set("parameters/attack/BlendSpace1D/blend_position", direction.x)
					# Delay for a short period
					await get_tree().create_timer(0.6).timeout
					shoot_ball_of_gust(player)
				else:
					anim_tree.get("parameters/playback").travel("flying idle")
					anim_tree.set("parameters/flying idle/BlendSpace1D/blend_position", direction.x)
		else:
			# Idle when not flying
			velocity = Vector3.ZERO
			anim_tree.get("parameters/playback").travel("ground idle")
			anim_tree.set("parameters/flying idle/BlendSpace1D/blend_position", direction.x) 
			
	else:
		velocity = Vector3.ZERO  # Stop moving if player is null 
	
	move_and_slide()

func _on_attack_timer_timeout() -> void:
	canAttack = true

#Shoot out a ball of gust
func shoot_ball_of_gust(player) -> void:
	if player:
		var projectile = ballofgust_scene.instantiate() as RigidBody3D
		# Add to scene FIRST to ensure proper global coordinates
		get_tree().current_scene.add_child(projectile)  
		projectile.global_transform.origin = marker.global_transform.origin
		
		# Calculate direction to player's position AT THIS MOMENT
		projectile.set_direction(player.global_transform.origin)


func _on_health_health_depleted() -> void:
	queue_free()
