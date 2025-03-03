extends Node

# vars for specific playback
@export var background_music: AudioStreamPlayer
@export var anthill_music: AudioStreamPlayer
@export var boss_music: AudioStreamPlayer
var tween: Tween

# creates and configures the music players
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
	
	# Create the boss music player
	boss_music = AudioStreamPlayer.new()
	boss_music.stream = preload("res://Music/newbossmusic.wav")
	add_child(boss_music)


func fade_out_music(music: AudioStreamPlayer):
	if music.playing:
		var tween = create_tween()
		tween.tween_property(music, "volume_db", -30, 1.0)
		await tween.finished
		music.stop()

func fade_in_music(music: AudioStreamPlayer):
	music.volume_db = -30
	music.play()
	var tween = create_tween()
	tween.tween_property(music, "volume_db", 0, 1.0)


func stop_background():
	if background_music.playing:
		fade_out_music(background_music)

func play_anthill_music():
	fade_in_music(anthill_music)

func stop_anthill_music():
	fade_out_music(anthill_music)

func play_boss_music():
	fade_in_music(boss_music)

func stop_boss_music():
	fade_out_music(boss_music)
