"""
	To call a dialog use DialogManager.start_dialogue(global_position, lines)
	global_position is for the character saying the lines.
	lines needs to be an array of strings. Example:
	Array[String] = 
"""
extends Node

@onready var text_box_scene = preload("res://scenes/UI/textbox.tscn").instantiate()

var dialog_lines: Array[String] = []

var current_line: int = 0

var text_box
var text_box_position: Vector2

var dialog_state: bool = false
var can_advance_line: bool = false
func start_dialog(position: Vector2, lines: Array[String]):
		#if the dialog is active, don't start a new one
		if dialog_state:
			return
			
		dialog_lines = lines
		text_box_position = position
		_show_text_box()
		
		dialog_state = true
		
func _show_text_box():
	text_box = text_box_scene.get_node("Label3D/Textbox")
	text_box.finished_displaying.connect(_on_finished_displaying)
	get_tree().root.add_child(text_box_scene)
	text_box.global_position = text_box_position
	text_box.displayText(dialog_lines[current_line])
	can_advance_line = false

func _on_finished_displaying():
	can_advance_line = true
	
func _unhandled_input(event):
		if (event.is_action_pressed("advance_dialog") &&
		dialog_state && can_advance_line):
			text_box.queue_free()
			
			current_line += 1
			if current_line >= dialog_lines.size():
				dialog_state = false
				current_line = 0
				return
			
			_show_text_box()
