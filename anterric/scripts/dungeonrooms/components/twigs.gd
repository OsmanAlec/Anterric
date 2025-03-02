extends Node3D

@export var twig = preload("res://inventory/items/twig.tres")

func _on_break_box_broken() -> void:
	PlayerData.collect(twig)
	
