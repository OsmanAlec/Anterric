extends RigidBody3D

@export var speed: float = 7.0

func _ready() -> void:
	gravity_scale = 0  # Disable gravity (optional)
	$VisibleOnScreenNotifier3D.screen_exited.connect(queue_free)
	$animation.play("gust ball", 1.0)

# Direction is set ONCE when spawned
func set_direction(target_position: Vector3) -> void:
	# Calculate the full direction vector
	var direction = target_position - global_transform.origin
	# Remove any vertical component to make the movement horizontal
	direction.y = 0
	# Avoiding division by zero 
	if direction == Vector3.ZERO:
		direction = Vector3.FORWARD
	else:
		direction = direction.normalized()
	# Apply the horizontal velocity
	linear_velocity = direction * speed
