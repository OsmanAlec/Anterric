extends Node

enum Stage {
	prologue,
	level1,
	level2,
	queenbeeboss,
}

var max_health: int = 20
var current_health: int = max_health
var applied_poison: int = 0
var coins = 0
@onready var player: CharacterBody3D = get_tree().get_first_node_in_group("Player")
var inventory: maininv = load("res://inventory/inv2/playerinv.tres")

var current_stage = Stage.prologue

func change_health (value: int)-> void:
	current_health = value
	
	
