extends Node

var canProgress = false

func _ready():
	MusicManagerSingleton.stop_background()
	MusicManagerSingleton.play_anthill_music()
	if PlayerData.completed_quests == 3:
		canProgress = true

func _process(delta: float) -> void:
	if canProgress:
		if QuestControl.completed_quests.is_empty():
			PlayerData.current_stage += 1
			PlayerData.completed_quests = 0
			canProgress = false
	
func _exit_tree():
	MusicManagerSingleton.stop_anthill_music()
	MusicManagerSingleton.background_music.play()
