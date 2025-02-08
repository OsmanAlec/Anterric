extends CharacterBody3D

const SPEED = 5.0
var isFlying:bool = false
var state:String = "idle"


func _physics_process(delta: float) -> void:
	
	$Animations.play(state)
	
	if Input.is_action_just_pressed("primary_attack"):
		$Animations.set_flip_h(true) #all this does is if player attacks, ladybug turns to the left side




	move_and_slide()
