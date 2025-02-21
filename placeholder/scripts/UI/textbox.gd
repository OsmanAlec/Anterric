extends MarginContainer

@onready var label = $MarginContainer/Label
@onready var timer = $LetterDisplayTimer

const MAX_WIDTH = 1024

var text = ""
var letter_index = 0

var letter_time = 0.03
var space_time = 0.06
var punction_time = 0.2

signal finished_displaying()

func displayText(text_to_display: String):
	text = text_to_display
	label.text = text
	await minimum_size_changed
	custom_minimum_size.x = min (size.x, MAX_WIDTH)
	
	#In case the size gets too big for max width
	if size.x > MAX_WIDTH:
		label.autowrap_mode = TextServer.AUTOWRAP_WORD
		await resized #wait for x to be resized
		await resized # wait for y to be resized
		custom_minimum_size.y = size.y
		
	
	label.text = ""
	_display_letter()
	
func _display_letter ():
	label.text += text[letter_index]
	letter_index += 1
	#return once the string end is reached
	if letter_index >= text.length():
		finished_displaying.emit()
		letter_index = 0 #reset for other dialog
		return
	
	match text[letter_index]:
		" ":
			timer.start(space_time)
		"!", "?", ",", ".":
			timer.start(punction_time)
		#Default value for letters
		_:
			timer.start(letter_time)
	


func _on_letter_display_timer_timeout() -> void:
	_display_letter()
