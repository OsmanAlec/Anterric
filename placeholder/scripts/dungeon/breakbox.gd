class_name BreakBox
extends Area3D

var broken = false

func _ready():
	connect("area_entered", Callable(self, "_on_area_entered"))

func _on_area_entered(hitbox: HitBox) -> void:
	"""Break an item with this function using same hitboxes."""
	if hitbox != null && !broken:
		%Animations.play("break")
		broken = true
		print("I'm broken!!!!!!")
		#give player the item dynamically, not sure how to do this yet
		
