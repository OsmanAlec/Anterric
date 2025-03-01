extends Node3D


func _on_item_pickup_item_pickedup() -> void:
	queue_free()
