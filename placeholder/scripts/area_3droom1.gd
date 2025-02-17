extends Area3D

var entered = false 

func _on_body_entered(body: PhysicsBody3D) -> void:
	entered = true
	print ("inbox")

func _on_body_exited(body: PhysicsBody3D) -> void:
	entered = false 
	print("notinboc")

func _physics_process(delta):
	if entered == true:

		get_tree().change_scene_to_file("res://scenes/room_no2.tscn")
