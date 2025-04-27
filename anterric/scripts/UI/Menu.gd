extends Node


@onready var OptionsMenuScene = get_node("OptionsMenu")
@onready var splash_screen = get_node("SplashScreen")
@onready var default_button = get_node("SplashScreen/CenterContainer/VBoxContainer/Play")

func _ready()->void:
	PlayerData.HUD.visible = false
	default_button.grab_focus()

func _on_play_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/dungeonrooms/Tutorial.tscn")

func _on_options_pressed() -> void:
	OptionsMenuScene.visible = true
	splash_screen.visible = false
	OptionsMenuScene.default_button.grab_focus()

func _on_options_menu_back_pressed() -> void:
	OptionsMenuScene.visible = false
	splash_screen.visible = true
	default_button.grab_focus()

func _on_quit_pressed() -> void:
	get_tree().quit()
