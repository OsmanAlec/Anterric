extends RigidBody3D

@export var speed: float = 7.0

func _ready() -> void:
	gravity_scale = 0  # Disable gravity (optional)
	$VisibleOnScreenNotifier3D.screen_exited.connect(queue_free)
	$animation.play("gust ball", 1.0)

# Direction is set ONCE when spawned (no physics_process needed)
func set_direction(target_position: Vector3) -> void:
	#direcition.y = self.location.y
	#Harshit please do this :>
	var direction = (target_position - global_transform.origin).normalized()
	linear_velocity = direction * speed  # Fixed direction
