extends Node3D

var leaf = preload("res://inventory/items/leaf.tres")

func _on_break_box_broken() -> void:
	PlayerData.collect(leaf)
