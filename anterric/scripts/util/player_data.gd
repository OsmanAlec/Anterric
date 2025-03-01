extends Node

const Stage: Array[String] = [
	"prologue",
	"level1",
	"level2",
	"queenbeeboss",
]

var max_health: int = 20
var current_health: int = max_health
var applied_poison: int = 0
var coins: int = 0 : set = set_coin, get = get_coin
@onready var player: CharacterBody3D = get_tree().get_first_node_in_group("Player")
var inventory: maininv = load("res://inventory/inv2/playerinv.tres")

var current_stage: int = 0 #index for Stage

func change_health (value: int)-> void:
	current_health = value

	
func set_coin(value: int):
	print(value)
	coins = value
	GameManager.coin = coins
	
func get_coin() -> int:
	return coins
	
func collect(item):
	inventory.insert(item)
	
