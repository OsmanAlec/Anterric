class_name BreakBox
extends Area3D

var isBroken = false
@export var resource: invitem2
@export var dropped_item_will_follow : bool = true
var pickup_scene: PackedScene = preload("res://inventory/items/item.tscn")

signal broken

func _ready():
	connect("area_entered", Callable(self, "_on_area_entered"))

func _on_area_entered(hitbox: HitBox) -> void:
	"""Break an item with this function using same hitboxes."""
	if hitbox != null && !isBroken:
		%Animations.play("break")
		isBroken = true
		emit_signal("broken") #send a signal broken to any item
		if dropped_item_will_follow:
			var pickup = pickup_scene.instantiate() as Node3D
			pickup.resource = resource
			pickup.global_position = get_parent().global_position
			get_tree().current_scene.add_child(pickup)
		
