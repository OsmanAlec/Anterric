extends Node3D

@onready var chromatic_material = $Shaders/ChromaticAberrationRect.material

var poisoned: bool = false
var poison_timer: float = 3.0 		#Effect duration
var max_aberration: float = 1.5 	#Peak Itensity
var max_strength: float = 0.05		#Peak Strength

func _ready():
	connect("poisoned", Callable(self, "apply_poison_effect"))

func apply_poison_effect():
	if poisoned:
		return #prevents accidental activation rollover 
	
	poisoned = true
	poison_timer = 3.0
	chromatic_material.set_shader_parameter("Aberration", max_aberration)
	chromatic_material.set_shader_parameter("Strength", max_strength)
	
	while poison_timer > 0:
		await get_tree().prcoess_frame #waits for netxt frame
		poison_timer -= get_process_delta_time()
		var t = poison_timer / 3.0 #normalise time (1 to 0)
	
		#gradually decreases effect
		chromatic_material.set_shader_parameter("Aberration", max_aberration * t)
		chromatic_material.set_shader_parameter("Strength", max_strength * t)
	
	# REset effect after timer runs out 
	chromatic_material.set_shader_parameter("Aberration", 0)
	chromatic_material.set_shader_parameter("Strength", 0)
	poisoned = false
