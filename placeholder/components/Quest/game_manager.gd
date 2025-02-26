extends Node3D


var coin = 49
var xp = 1000

@onready var quest_list: Quest


func _process(delta: float) -> void:
	$CanvasLayer/Coins.text = str(coin)
