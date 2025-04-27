extends Node

var canProgress = false
@export var door: Node3D #reference to the door
var open_door: bool = false

func _ready():
	PlayerData.current_health = PlayerData.max_health
	MusicManagerSingleton.stop_background()
	MusicManagerSingleton.play_anthill_music()
	open_door = false

func _process(delta: float) -> void:
	if PlayerData.completed_quests == 3 and !canProgress:
		canProgress = true
	if canProgress:
		if QuestControl.completed_quests.is_empty():
			GameManager.current_stage += 1
			PlayerData.completed_quests = 0
			get_node("Garvan/TalkToMe").visible = true
			get_node("Garvan/TalkToMe").modulate = Color(1, 1, 1, 1)
			get_node("Manfred/TalkToMe").visible = true
			get_node("Manfred/TalkToMe").modulate = Color(1, 1, 1, 1)
			get_node("Erric/TalkToMe").visible = true
			get_node("Erric/TalkToMe").modulate = Color(1, 1, 1, 1)
			canProgress = false
	if !QuestControl.active_quests.is_empty() and !open_door:
		door.open()
		open_door = true
	
	
func _exit_tree():
	MusicManagerSingleton.stop_anthill_music()
	MusicManagerSingleton.background_music.play()
