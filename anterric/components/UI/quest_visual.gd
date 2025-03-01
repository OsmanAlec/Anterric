extends VBoxContainer

var is_open = false

func _physics_process(delta):
	if Input.is_action_just_pressed("quest"):
		if is_open:
			close()
		else:
			open()
			
func open():
	visible = true
	is_open = true
func close():
	visible = false
	is_open = false
