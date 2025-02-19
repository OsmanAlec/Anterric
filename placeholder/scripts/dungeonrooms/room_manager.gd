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
		var current_num: int = int(str(get_tree().get_current_scene().get_name())[-1])
		var room_num: int = randi_range(1,5)
		print(room_num, current_num)
		if room_num == current_num:
			room_num = (room_num + 1) % 5 + 1
		get_tree().change_scene_to_file("res://scenes/dungeonrooms/room_no" + str(room_num) + ".tscn")
		
