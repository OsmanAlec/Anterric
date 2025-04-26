extends Control

signal back_pressed

@onready var default_button = get_node("Options/Main/Back")

func _on_back_pressed() -> void:
	back_pressed.emit()


func _on_options_tab_changed(tab: int) -> void:
	default_button = get_node("Options").get_child(tab).get_node("Back")
