extends VBoxContainer

@onready var ToolTip = get_node("ToolTip")

func _physics_process(delta):
	if Input.is_action_just_pressed("quest"):
		await get_tree().create_timer(0.1).timeout
		if visible:
			if ToolTip:
				ToolTip.visible = false
			visible = false
		else:
			visible = true
			
