extends Node

var max_health: int = 20
var current_health: int = max_health
var applied_poison: int = 0
@onready var player: CharacterBody3D = get_tree().get_first_node_in_group("Player")

func change_health (value: int)-> void:
	current_health = value
	
	
