extends Area3D

var entered = false 

func _on_body_entered(body: PhysicsBody3D) -> void:
	entered = true
	print ("in box")

func _on_body_exited(body: PhysicsBody3D) -> void:
	entered = false 
	print("notinboc")

func _physics_process(delta):
	if entered == true:

		print("succwess")
