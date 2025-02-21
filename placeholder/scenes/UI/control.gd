extends Control

func _on_textbox_resized() -> void:
	print("Resized")
	size.x = %Textbox.size.x
	size.y = %Textbox.size.y
