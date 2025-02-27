extends Node3D


# Called when the node enters the scene tree for the first time.
#func _ready() -> void:
	#connect()



func _on_item_pickup_item_picked_up() -> void:
	queue_free()
