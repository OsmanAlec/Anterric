extends Node3D


var coin = 49
var xp = 1000

@onready var quest_list: Quest
@onready var sfx_hit = $Hitsound
@onready var sfx_dash = $Dash


func _process(delta: float) -> void:
	$CanvasLayer/Coins.text = str(coin)
