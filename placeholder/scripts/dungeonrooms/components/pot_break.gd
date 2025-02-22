extends Node3D

var quest: SearchQuest

# Preload the 3D Coin scene
const Coin = preload("res://scenes/dungeonrooms/components/Coin.tscn") 

func _on_break_box_broken() -> void:
	# Spawn the coin
	var coin = Coin.instantiate()
	add_child(coin) 
	# Position the coin slightly above the pot
	coin.global_position = global_position + Vector3(0, 0.5, 0)
	
	#NEWCODE
func _on_body_entered(body) -> void:
	if body.is_in_group("Player"):
		quest.reached_goal()
		queue_free()
	#NEWCODE
