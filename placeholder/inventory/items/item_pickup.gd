extends Area3D

@export var item: invitem2

var bomb = preload("res://inventory/items/bomb.tscn")
var player = null

func _on_area_entered(area: Area3D) -> void:
	player.collect(item)
