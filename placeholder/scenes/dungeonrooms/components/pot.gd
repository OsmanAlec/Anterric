extends Node3D

var broken = false

func _ready():
	connect("area_entered", Callable(self, "_on_area_entered"))

func _on_area_entered(hitbox: HitBox) -> void:
	"""Break an item with this function using same hitboxes."""
	if hitbox != null && !broken:
		broken = true
		#give player the item dynamically, not sure how to do this yet
		var coin = load("res://scenes/coin.tscn")
		var instance = coin.instantiate()
		add_child(instance)
