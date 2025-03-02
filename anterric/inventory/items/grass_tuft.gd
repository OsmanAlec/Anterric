extends Node3D
var speed = 0.25

func _on_item_pickup_item_pickedup() -> void:
	
	await get_tree().create_timer(0.5).timeout
	queue_free()
