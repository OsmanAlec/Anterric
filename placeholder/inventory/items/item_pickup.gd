extends Area3D

@export var item: invitem2
@onready var player = get_tree().get_first_node_in_group("Player")

signal item_picked_up


func _on_body_entered(body: Node3D) -> void:
	if body == player:	
		player.collect(item)
		item_picked_up.emit()
	
