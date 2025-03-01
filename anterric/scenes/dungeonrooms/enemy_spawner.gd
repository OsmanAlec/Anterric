extends Node3D
class_name enemies_spawner

@export var enemy_scenes: Array  # Array to hold different enemy scenes
@export var min_enemies: int = 2  # Minimum number of enemies to spawn
@export var max_enemies: int = 5  # Maximum number of enemies to spawn
@export var enemies_parent: NodePath  # Reference to the Enemies node

@onready var spawn_points := get_children()  # Get all spawn markers
@onready var num_enemies = randi_range(min_enemies, max_enemies)

func spawn_enemies():
	print("Spawning", num_enemies, "enemies!")

	var enemies_container = get_node(enemies_parent)
	var available_spawns = spawn_points.duplicate()

	var projectile_scene: PackedScene = load("res://scenes/enemies/ladybug/ballofgust.tscn")

	for i in range(num_enemies):
		if available_spawns.is_empty():
			print("No spawn points found!")
			return

		var spawn_location = available_spawns.pick_random()
		available_spawns.erase(spawn_location)

		var enemy_scene = enemy_scenes.pick_random()
		var enemy = enemy_scene.instantiate()

		if enemy.has_method("set_projectile_scene"):  
			enemy.set_projectile_scene(projectile_scene)
		
		# ✅ Set initial position above spawn
		var start_position = spawn_location.global_transform.origin + Vector3(0, 10, 0)
		enemy.global_transform.origin = start_position

		enemies_container.add_child(enemy)

		# ✅ Tween animations
		var tween = get_tree().create_tween()
		tween.parallel().tween_property(enemy, "global_transform:origin", spawn_location.global_transform.origin, 0.5).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
		tween.parallel().tween_property(enemy, "scale", Vector3(1, 1, 1), 0.5).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)

		
		tween.tween_property(enemy, "global_transform:origin:y", spawn_location.global_transform.origin.y + 0.2, 0.2).set_trans(Tween.TRANS_BOUNCE)


	enemies_container.update_enemy_count()
