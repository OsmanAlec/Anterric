extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	MusicManagerSingleton.stop_background()
	MusicManagerSingleton.play_anthill_music()


func _exit_tree():
	MusicManagerSingleton.stop_anthill_music()
	MusicManagerSingleton.background_music.play()
