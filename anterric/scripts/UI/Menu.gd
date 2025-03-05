extends Control

func _ready() -> void:
	GameManager.get_node("Coins").visible = false


func _on_play_pressed() -> void:
	GameManager.get_node("Coins").visible = true
	get_tree().change_scene_to_file("res://scenes/home/ant_hill.tscn")

func _on_options_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/UI/options_menu.tscn")


func _on_quit_pressed() -> void:
	get_tree().quit()
