extends Node3D
var speed = 0.25

@export var resource : invitem2

func _ready() -> void:
	if resource:
		$Sprite3D.texture = resource.texture
		$item_pickup.item = resource

func _on_item_pickup_item_pickedup() -> void:
	
	await get_tree().create_timer(0.5).timeout
	queue_free()
