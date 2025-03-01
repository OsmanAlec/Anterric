extends Node

func _ready():
	MusicManagerSingleton.stop_background()
	MusicManagerSingleton.play_anthill_music()
	
func _exit_tree():
	MusicManagerSingleton.stop_anthill_music()
	MusicManagerSingleton.background_music.play()
