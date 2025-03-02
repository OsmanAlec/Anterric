extends Node3D


func _on_coin_pickup_coin_pickedup() -> void:
	PlayerData.coins += 1 #since this coin is only worth 1
	queue_free()
