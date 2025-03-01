extends Node3D

# Preload the 3D Coin scene
const Coin = preload("res://scenes/dungeonrooms/components/Coin.tscn") 

func _on_break_box_broken() -> void:
	# Spawn the coin
	var coin = Coin.instantiate()
	add_child(coin) 
	
	# Position the coin slightly above the pot
	coin.global_position = global_position + Vector3(0, 0.5, 0)
		
