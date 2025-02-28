extends Area3D


var entered = false 

func _on_body_entered(body: PhysicsBody3D) -> void:
	print("entered")
	entered = true
	
func _on_body_exited(body: PhysicsBody3D) -> void:
	print("exited")
	entered = false 
	

func _physics_process(delta):
	
	if entered == true:
	
			get_tree().change_scene_to_file("res://scenes/dungeonrooms/room_no1.tscn")
			
	
