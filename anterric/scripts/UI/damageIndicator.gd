extends Node3D

var speed = 4
const FRICTION = 2
var direction: Vector3 = Vector3.ZERO

@onready var label = $Label3D

func _ready():
	direction = Vector3(randf_range(-1, 1), randf_range(-1, 1), 0)
	
func _process(delta: float) -> void:
	global_position += speed * direction * delta
	speed = max(speed-FRICTION * delta, 0)
