extends Node3D


func _ready()-> void:
	MusicManagerSingleton.stop_boss_music()
	$Player.lastDir.x = 1
	$Player.canMove = false
	PlayerData.HUD.visible = false
	$Control/AnimationPlayer.current_animation = "fade_in"
	await get_tree().create_timer(1.0).timeout
