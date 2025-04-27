extends Node

@onready var player: CharacterBody3D = get_tree().get_first_node_in_group("Player")
@onready var max_health: int = 6
@onready var current_health: int = max_health
@onready var damage: int = 2
@onready var heart_hud = PlayerManager.get_node("HUD/Hearts")
@onready var HUD = PlayerManager.get_node("HUD")

var completed_quests : int = 0
var coins: int = 0 : set = set_coin
var inventory: maininv = load("res://inventory/inv2/playerinv.tres")
var completed_stages: int = 0
	
func set_coin(value: int):
	coins = value
	HUD.get_node("Coin/Coins").text = str(coins)
	QuestControl.check_quests()
	
func collect(item):
	await inventory.insert(item)
	QuestControl.check_quests()

func _on_health_changed(diff: int) -> void:
	if current_health == current_health + diff:
		return
	current_health += diff
	heart_hud.update_health(current_health)
	
func _on_max_health_changed(value: int) -> void:
	max_health = value
	heart_hud.update_max_health(max_health)
