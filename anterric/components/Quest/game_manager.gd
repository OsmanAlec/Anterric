extends Node3D

const Stage: Array[String] = [
	"prologue",
	"level1",
	"level2",
	"queenbeeboss",
]


@onready var sfx_hit = $Hitsound
@onready var sfx_dash = $Dash

var current_stage: int = 0 #index for Stage
