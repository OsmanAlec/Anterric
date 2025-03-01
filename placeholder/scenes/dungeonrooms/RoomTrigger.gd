extends Area3D

signal player_entered  # Signal to notify room script


func _on_body_entered(body):
	
	if body.name == "Player":  # Ensure it's the player
		player_entered.emit()  # Notify Room.gd
