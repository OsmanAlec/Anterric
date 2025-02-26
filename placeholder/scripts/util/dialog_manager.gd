"""
	To call a dialog use DialogManager.start_dialogue(global_position, lines)
	global_position is for the character saying the lines.
	lines needs to be an array of strings. Example:
	Array[String] = 
"""
extends Node3D

# Signal emitted when the dialog finishes
signal finished_talking(char_name: String)

# Variables for managing dialogue
var dialog_lines: Array[String] = []
var current_line: int = 0
var text_box_scene
var text_box
var text_box_position: Vector3
var dialog_state: bool = false
var can_advance: bool = false
var char_name: String

@onready var player = get_tree().current_scene.get_node("Player")

# Starts a dialogue at a given position with an array of lines
func start_dialog(position: Vector3, lines: Array[String], caller: String):
	# If a dialog is already active, allow advancing but don't restart
	if dialog_state:
		can_advance = true
		return
	#Track down which character is talking
	char_name = caller
	
	# Disable player movement
	player.canMove = false
	
	# Store dialog data
	dialog_lines = lines
	text_box_position = position
	
	# Show first line of dialogue
	await _show_text_box()
	await get_tree().create_timer(0.3).timeout
	dialog_state = true

# Handles displaying the text box and setting its position
func _show_text_box():
	# Instance a new text box scene
	text_box_scene = preload("res://scenes/UI/textbox.tscn").instantiate()
	text_box = text_box_scene.get_node("%Textbox")

	# Add it to the scene tree
	get_tree().root.add_child(text_box_scene)

	# Adjust position based on speaker (RQUEEN is the response from the queen)
	if dialog_lines[current_line].begins_with("RQUEEN"):
		text_box_scene.global_position = player.global_position
		text_box.displayText(dialog_lines[current_line].replace("RQUEEN ", ""))
	else:
		text_box_scene.global_position = text_box_position
		text_box.displayText(dialog_lines[current_line])

	# Offset the text box slightly upwards
	text_box_scene.global_position.y += 0.5

# Handles advancing the dialog when the player presses the "advance_dialog" action
func _unhandled_input(event):
	if event.is_action_released("advance_dialog") and dialog_state and can_advance:
		print("hey")
		# Hide the current text box
		text_box_scene.queue_free()

		# Move to the next line
		current_line += 1

		# If all lines are finished, reset state and emit signal
		if current_line >= dialog_lines.size():
			dialog_state = false
			current_line = 0
			player.canMove = true
			finished_talking.emit(char_name)
			return
		
		# Show the next line of dialogue
		_show_text_box()
