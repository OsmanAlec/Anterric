extends Area3D

static var counter = 0
var entered = false 

func _on_body_entered(body: PhysicsBody3D) -> void:
	entered = true

func _on_body_exited(body: PhysicsBody3D) -> void:
	entered = false 
	

func _physics_process(delta):
	
	
	if entered == true:
		var current_num: int = int(str(get_tree().get_current_scene().get_name())[-1])
		var room_num: int = randi_range(1,4)
		
		counter = counter + 1 
		
		if counter > 5:
			get_tree().change_scene_to_file("res://scenes/dungeonrooms/room_no5.tscn")
		else:
			room_num = (room_num + 1) % 4 + 1
			get_tree().change_scene_to_file("res://scenes/dungeonrooms/room_no" + str(room_num) + ".tscn")
		
		
