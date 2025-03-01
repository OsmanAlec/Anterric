extends Sprite3D

func _on_textbox_minimum_size_changed() -> void:
	offset.x = (1024-%Textbox.size.x)/2
