extends Node

# vars for specific playback
@export var background_music: AudioStreamPlayer
@export var anthill_music: AudioStreamPlayer

# creates and configures background music player
func _ready():
	# Create the background music player
	background_music = AudioStreamPlayer.new()
	background_music.stream = preload("res://music/dungeonmusic8bit.wav")
	add_child(background_music)
	background_music.play()

	# Create the anthill music player
	anthill_music = AudioStreamPlayer.new()
	anthill_music.stream = preload("res://music/AntHillMusic(2).wav")
	add_child(anthill_music)

func stop_background():
	if background_music.playing:
		background_music.stop()

func play_anthill_music():
	anthill_music.play()

func stop_anthill_music():
	anthill_music.stop()
