extends Node3D

var health_increase: int = 1  # Default healing value.
var heart_type: String = "full"       # Default heart type.

# Sets the heart type and assigns the corresponding healing value and texture.
func set_heart_type(type: String) -> void:
	heart_type = type
	if heart_type == "full":
		health_increase = 2  # Full heart restores 2 health.
		$Sprite3D.texture = preload("res://art/UI/heart_1.png")
	elif heart_type == "half":
		health_increase = 1  # Half heart restores 1 health.
		$Sprite3D.texture = preload("res://art/UI/heart_2.png")

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group("Player"):
		# Check if player is already at max health before applying healing
		if PlayerData.current_health < PlayerData.max_health:
			body.get_node("Health").health += health_increase
			await get_tree().create_timer(0.2).timeout
			queue_free()  # Remove the heart after pickup.
