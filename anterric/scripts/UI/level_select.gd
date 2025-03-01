extends Control


func _on_dungeon_level_1_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/world.tscn")


func _on_dungeon_level_2_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/room_no2.tscn")
