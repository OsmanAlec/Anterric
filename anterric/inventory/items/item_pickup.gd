extends Area3D

signal item_pickedup

@export var item: invitem2
@onready var player = get_tree().get_first_node_in_group("Player")


func _on_body_entered(body: Node3D) -> void:
	if player == body:
		print("heeyyyyy")
		item_pickedup.emit()
		player.collect(item)
