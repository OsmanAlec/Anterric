extends Control

func _physics_process(delta):
	if Input.is_action_just_pressed("quest"):
		await get_tree().create_timer(0.1).timeout
		if visible:
			visible = false
		else:
			visible = true
			
