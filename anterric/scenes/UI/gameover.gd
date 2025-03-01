extends CanvasLayer


func _on_retry_pressed() -> void:
	PlayerData.current_health = PlayerData.max_health
	get_tree().change_scene_to_file("res://scenes/home/ant_hill.tscn")
	


func _on_quit_pressed() -> void:
	get_tree().quit()
