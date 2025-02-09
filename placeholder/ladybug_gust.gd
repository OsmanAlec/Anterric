extends RigidBody3D

@export var speed:int = 5.0
var diection : Vector3
# Called when the node enters the scene tree for the first time.
func _read():
	pass

func _process(delta: float) -> void:
	$animation.play("gust ball", 4.0)
	
	move_and_collide(transform.basis.z * delta * speed)
	


func _on_body_entered(body: Node) -> void:
	if body.is_in_group("HitObject"):
		print("I'm hit!")
		body.queue_free()
		queue_free()
