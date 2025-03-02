extends Area3D

@export var health_increase: int = 1  # Default healing value.
var heart_type: String = "full"         # Default heart type.

func _ready() -> void:
	connect("body_entered", Callable(self, "_on_body_entered"))

# Sets the heart type and assigns the corresponding healing value and texture.
func set_heart_type(type: String) -> void:
	heart_type = type
	if heart_type == "full":
		health_increase = 2  # Full heart restores 2 health.
		$Sprite3D.texture = preload("res://art/UI/heart_1.png")
	elif heart_type == "half":
		health_increase = 1  # Half heart restores 1 health.
		$Sprite3D.texture = preload("res://art/UI/heart_2.png")

# When the player touches the heart, increase their health and remove the heart.
func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("Player"):
		var health_node = body.get_node_or_null("Health")
		if health_node:
			health_node.increase_health(health_increase)
			print("Picked up a %s heart! Health increased by %d" % [heart_type, health_increase])
		else:
			print("Health node not found on player!")
		queue_free()  # Remove the heart after pickup.
