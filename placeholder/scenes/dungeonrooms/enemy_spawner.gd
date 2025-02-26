extends Node3D
class_name enemies_spawner

@export var enemy_scene: PackedScene  # Drag and drop enemy scene in Inspector
@export var min_enemies: int = 2  # Minimum number of enemies to spawn
@export var max_enemies: int = 5  # Maximum number of enemies to spawn
@export var enemies_parent: NodePath  # Reference to the Enemies node


@onready var spawn_points := get_children()  # Get all spawn markers
@onready var num_enemies = randi_range(min_enemies, max_enemies)

func spawn_enemies():
	  # Pick random number
	print("Spawning", num_enemies, "enemies!")
	
	var enemies_container = get_node(enemies_parent)  # Reference to Enemies node
	var available_spawns = spawn_points.duplicate()
	
	for i in range(num_enemies):
		if spawn_points.is_empty():
			print("No spawn points found!")
			return
		
		var spawn_location = available_spawns.pick_random()  # Pick a random spawn point
		available_spawns.erase(spawn_location)  # Remove it from available options  # Pick a random spawn point
		var enemy = enemy_scene.instantiate()  # Create enemy instance
		enemy.global_transform.origin = spawn_location.global_transform.origin  # Set position
		enemies_container.add_child(enemy)  # Add enemy under the Enemies node
	enemies_container.update_enemy_count()
