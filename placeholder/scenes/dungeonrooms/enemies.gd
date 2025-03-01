
extends enemies_spawner


@export var door : Node3D  # Reference to the door



	
func _ready():
	
	
	
	await get_tree().create_timer(0.1).timeout
	update_enemy_count()
	
	
	# Connect to each enemy's "died" signal
	for enemy in get_children():
		if enemy.has_signal("died"):
			enemy.connect("died", _on_enemy_died)

func update_enemy_count():
	await get_tree().process_frame
	var enemies_left = get_child_count()
	
	print("Enemies left:", enemies_left)  

	if enemies_left == 0:
		print("All enemies defeated. Calling open_door()") 
		if door:
			door.open()
		else:
			print("ERROR: No door assigned!")
		open_door()

func _on_enemy_died():
	print("An enemy died!") 
	update_enemy_count()

func open_door():
	print("open_door() function called!")  
	if door:
		print("Calling door.open() function!") 
		door.open()
	else:
		print("ERROR: No door assigned in Enemies.gd")
