extends Area3D
static var counter = 0
var entered = false 
var stage:String = GameManager.Stage[GameManager.current_stage]

func _on_body_entered(body: PhysicsBody3D) -> void:
	entered = true
	
func _on_body_exited(body: PhysicsBody3D) -> void:
	entered = false 
	

func _physics_process(delta):
	if entered == true:
		var current_num: int = int(str(get_tree().get_current_scene().get_name())[-1])
		
		var room_num: int = randi_range(1,3)
		
		while current_num == room_num:
			room_num = randi_range(1,3)
			
		#if we are at a stage where we can fight the queenbeeboss,
		#spawn boss room after 5 rooms
		if stage == "queenbeeboss":
			counter = counter + 1 
			if counter >= 5:
				get_tree().change_scene_to_file("res://scenes/dungeonrooms/room_no5.tscn")
			else:
				get_tree().change_scene_to_file("res://scenes/dungeonrooms/room_no" + str(room_num) + ".tscn")
		else:
			if !QuestControl.active_quests.is_empty():
				get_tree().change_scene_to_file("res://scenes/dungeonrooms/room_no" + str(room_num) + ".tscn")
			else:
				get_tree().change_scene_to_file("res://scenes/home/ant_hill.tscn")
				
		
