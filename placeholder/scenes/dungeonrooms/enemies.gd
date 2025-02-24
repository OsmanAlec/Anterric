extends Node3D

@export var door : Node3D  # Reference to the door

func _ready():
	update_enemy_count()
	
	# Connect to each enemy's "died" signal
	for enemy in get_children():
		if enemy.has_signal("died"):
			enemy.connect("died", _on_enemy_died)

func update_enemy_count():
	var enemies_left = get_child_count()
	enemies_left = enemies_left - 1
	print("Enemies left:", enemies_left)  # Debug message

	if enemies_left == 0:
		print("All enemies defeated. Calling open_door()")  # Debug message
		open_door()

func _on_enemy_died():
	print("An enemy died!")  # Debug message
	update_enemy_count()

func open_door():
	print("open_door() function called!")  # Debaug message
	if door:
		print("Calling door.open() function!")  # Debug message
		door.open()
	else:
		print("ERROR: No door assigned in Enemies.gd")
