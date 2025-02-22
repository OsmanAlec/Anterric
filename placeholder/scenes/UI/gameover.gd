extends CanvasLayer


func _on_retry_pressed() -> void:
	PlayerData.current_health = PlayerData.max_health
	get_tree().change_scene_to_file("res://scenes/dungeonrooms/room_no1.tscn")
	


func _on_quit_pressed() -> void:
	get_tree().quit()
