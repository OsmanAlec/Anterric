extends Node2D

func _ready() -> void:
	PlayerData.HUD.visible = false
	MusicManagerSingleton.stop_background()
	MusicManagerSingleton.stop_anthill_music()
	$Control/AnimationPlayer.current_animation = "fade_in"
	await get_tree().create_timer(0.5).timeout
	$AnimationTree.get("parameters/playback").travel("BlendTree")
	
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept"):
		$Control/AnimationPlayer.current_animation = "fade_out"
		await get_tree().create_timer(1).timeout
		get_tree().change_scene_to_file("res://credits.tscn")

func _start_fire() -> void:
	$AudioStreamPlayer.play()
