extends Node3D

var tuft = preload("res://inventory/items/grass_tuft.tscn").instantiate()


func _on_break_box_broken() -> void:
	
	add_child(tuft)
	
	tuft.global_position = global_position + Vector3(0, 0.5, 0)
