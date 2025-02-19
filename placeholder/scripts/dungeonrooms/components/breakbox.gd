class_name BreakBox
extends Area3D

var isBroken = false

signal broken

func _ready():
	connect("area_entered", Callable(self, "_on_area_entered"))

func _on_area_entered(hitbox: HitBox) -> void:
	"""Break an item with this function using same hitboxes."""
	if hitbox != null && !isBroken:
		%Animations.play("break")
		isBroken = true
		emit_signal("broken") #send a signal broken to any item
		
