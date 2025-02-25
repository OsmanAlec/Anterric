extends AudioStreamPlayer

const dungeon_music = preload("res://music/dungeonmusic8bit.wav")

func _play_music(music: AudioStream, volume = 0.0):
	if stream == music:
		return
	
	stream = music
	volume_db = volume

func play_music_level():
	_play_music(dungeon_music)
