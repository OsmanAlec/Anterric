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
	
	if enemies_left == 0:
		if door:
			door.open()
		else:
			push_error("Door not detected") 

func _on_enemy_died():
	update_enemy_count()
