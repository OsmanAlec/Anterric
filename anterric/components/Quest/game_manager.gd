extends Node3D


var xp = 1000

@onready var sfx_hit = $Hitsound
@onready var sfx_dash = $Dash


func _process(delta: float) -> void:
	$CanvasLayer/Coins.text = str(PlayerData.coins)
	
