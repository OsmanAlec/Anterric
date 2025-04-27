extends Control

func _ready() -> void:
	get_node("VBoxContainer/Button").grab_focus()

func _on_button_pressed() -> void:
	get_tree().quit()
