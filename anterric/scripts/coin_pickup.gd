extends Area3D


signal coin_pickedup

@export var coin: invitem2
@onready var player = get_tree().get_first_node_in_group("Player")


func _on_body_entered(body: Node3D) -> void:
	if player == body:
		print("heeyyyyy")
		coin_pickedup.emit()
