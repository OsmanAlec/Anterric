extends Area3D


var entered = false 

func _on_body_entered(body: PhysicsBody3D) -> void:
	entered = true
	
func _on_body_exited(body: PhysicsBody3D) -> void:
	entered = false 
	

func _physics_process(delta):
	
	if entered == true:
		var room_num: int = randi_range(1,3)
		get_tree().change_scene_to_file("res://scenes/dungeonrooms/room_no" + str(room_num) + ".tscn")
