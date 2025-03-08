extends Node3D

var scene_change = load("res://scenes/fadeout.tscn").instantiate()

func _ready()-> void:
	MusicManagerSingleton.stop_background()
	MusicManagerSingleton.play_boss_music()
	$Control/AnimationPlayer.current_animation = "fade_in"
	await get_tree().create_timer(1.0).timeout
	$Player.lastDir.x = 1
	GameManager.get_node("Coins").visible = false
	$Player.get_node("HUD").visible = false
	$Player.canMove = false
