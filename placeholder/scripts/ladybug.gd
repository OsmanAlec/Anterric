extends CharacterBody3D

@export var player_path: NodePath  # Follows the ant from world scene
const SPEED: float = 5.0

var state: String = "idle"

@export var detection_radius: float = 3.0  # Detection range for flying
@export var stopping_distance: float = 2.0  # Maintain distance when following
@export var flying_height: float = 0.4  # Target height when flying
@export var ascent_speed: float = 0.5  # Speed of flying up

var isFlying: bool = false  # Tracks if ladybug is flying
var flight_progress: float = 0.0  # Smooth flight transition

func _physics_process(delta: float) -> void:
	var player = get_node(player_path)
	
	if player:
		var distance = global_transform.origin.distance_to(player.global_transform.origin)

		# If the ant enters the detection radius, the ladybug takes off
		if distance < detection_radius and not isFlying:
			isFlying = true  # Enable flying mode

		if isFlying:
			# increase Y position to simulate flying using lerp
			flight_progress = min(flight_progress + ascent_speed * delta, 1.0)
			global_transform.origin.y = lerp(global_transform.origin.y, flying_height, flight_progress)

			# Follow player, but maintain stopping distance
			if distance > stopping_distance:
				var direction = (player.global_transform.origin - global_transform.origin).normalized()
				velocity = velocity.lerp(direction * SPEED, delta * 5) 
			else:
				velocity = Vector3.ZERO  # Stop if too close
		else:
			# Idle when not flying
			velocity = Vector3.ZERO

	else:
		velocity = Vector3.ZERO  # Stop moving if player is null

	$Animations.play(state)
	move_and_slide()
