extends Node3D

func _ready():
	$Animations.play("coin")
	

func _on_item_pickup_item_pickedup() -> void:
	PlayerData.coins += 1 #since this coin is only worth 1
	queue_free()
