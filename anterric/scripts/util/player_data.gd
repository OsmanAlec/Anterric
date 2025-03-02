extends Node

const Stage: Array[String] = [
	"prologue",
	"level1",
	"level2",
	"queenbeeboss",
]

var completed_quests : int = 0
var max_health: int = 6 : set = set_maxhp
var current_health: int = max_health
var applied_poison: int = 0
var coins: int = 0 : set = set_coin, get = get_coin
@onready var player: CharacterBody3D = get_tree().get_first_node_in_group("Player")
var inventory: maininv = load("res://inventory/inv2/playerinv.tres")

var current_stage: int = 0 #index for Stage

func _process(delta: float) -> void:
	if player != null:
		return
	player = get_tree().get_first_node_in_group("Player")

func change_health (value: int)-> void:
	current_health = value
	
func set_coin(value: int):
	coins = value
	QuestControl.check_quests()
	
func get_coin() -> int:
	return coins
	
func collect(item):
	await inventory.insert(item)
	QuestControl.check_quests()

func set_maxhp(value: int):
	player.get_node("Health").max_health = value
	max_health = value
	player.get_node("HUD").get_node("Hearts").update_max_health(value)
	current_health = value
	
func set_hp(value: int):
	if !player:
		return
	player.get_node("Health").health = value
	current_health = clamp(value, 0, max_health)
	print(current_health)
	player.get_node("HUD").get_node("Hearts").update_health(value)
	current_health = value
	

	
