"""
	To call a dialog use DialogManager.start_dialogue(global_position, lines)
	global_position is for the character saying the lines.
	lines needs to be an array of strings. Example:
	Array[String] = 
"""
extends Node3D

var dialog_lines: Array[String] = []

var current_line: int = 0

var text_box_scene

var text_box 
var text_box_position: Vector3

var dialog_state: bool = false
var canAdvance: bool = false

func start_dialog(position: Vector3, lines: Array[String]):
		
		#if the dialog is active, don't start a new one
		if dialog_state:
			canAdvance = true
			return
		
		get_tree().current_scene.get_node("Player").canMove = false
		dialog_lines = lines
		text_box_position = position
		text_box_position.y += 0.5
		_show_text_box()
		dialog_state = true
		
func _show_text_box():
		
	# Now instance a fresh scene
	text_box_scene = preload("res://scenes/UI/textbox.tscn").instantiate()
	text_box = text_box_scene.get_node("%Textbox")
	
	# Add it to the scene tree
	get_tree().root.add_child(text_box_scene)
	text_box_scene.global_position = text_box_position
	
	# Display the text
	text_box.displayText(dialog_lines[current_line])
	
	
func _unhandled_key_input(event):
	if (event.is_action_pressed("advance_dialog") &&
	dialog_state && canAdvance):
		text_box_scene.visible = false
		
		current_line += 1
		#Once the dialog lines are up
		if current_line >= dialog_lines.size():
			dialog_state = false
			current_line = 0
			get_tree().current_scene.get_node("Player").canMove = true
			return
		
		_show_text_box()
