extends Node3D

func _on_coin_pickup_coin_pickedup() -> void:
	PlayerData.coins += 15 #since this coin is worth 10
	queue_free()
