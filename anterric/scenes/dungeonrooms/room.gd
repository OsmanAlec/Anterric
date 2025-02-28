extends Node3D

@export var enemy_spawner: NodePath  # Drag and drop EnemySpawner in Inspector

func _on_player_entered():  # Call this when player enters the room
	var spawner = get_node(enemy_spawner)
	spawner.spawn_enemies()


func _on_room_trigger_body_entered(body: Node3D) -> void:
	var spawner = get_node(enemy_spawner)
	spawner.spawn_enemies()
