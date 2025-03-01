extends Control

func _on_textbox_minimum_size_changed() -> void:
	position.y += (32-%Textbox.size.y)/2
