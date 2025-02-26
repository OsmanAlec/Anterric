extends Node

var max_health: int = 6
var current_health: int = max_health
var applied_poison: int = 0

func change_health (value: int)-> void:
	current_health = value
	
	
