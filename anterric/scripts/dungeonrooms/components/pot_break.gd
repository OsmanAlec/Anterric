extends Node3D

# Preload the 3D Coin scene
var coin1 = preload("res://scenes/1coin.tscn").instantiate()
var coin10 = preload("res://scenes/10_coin.tscn").instantiate()
var coin15 = preload("res://scenes/15_coin.tscn").instantiate()

func _on_break_box_broken() -> void:
	# Spawn the coin
	var randcoin: int = randi_range(1, 20)
	#1 in 20 chance to get 15
	#5 in 20 chance to get 10
	#14 in 20 chance to get 1
	match randcoin:
		15:
			add_child(coin15) 
			coin15.global_position = global_position + Vector3(0, 0.1, 0)
		10,11,12,13,14:
			add_child(coin10)
			coin10.global_position = global_position + Vector3(0, 0.1, 0)
		_:
			add_child(coin1)
			coin1.global_position = global_position + Vector3(0, 0.1, 0)



		
