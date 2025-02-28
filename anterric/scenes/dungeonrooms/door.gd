extends StaticBody3D

func open():
	# Disable collision by changing to a non-blocking layer (e.g., layer 2 or 0)
	print("door openeing!!!")
	collision_layer = 0  
	collision_mask = 0  # Prevents interactions with other bodies
	$"branch door/AnimationPlayer".current_animation = "open"
