extends Node3D


var coin = 50
var xp = 1000


func _process(delta: float) -> void:
	$CanvasLayer/Coins.text = str(coin)
