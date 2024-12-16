extends CharacterBody2D

const RATE = 100
const SPEED = 4 * RATE
const ACCELERATION	 = 25 * RATE

func player_movement(input, delta):

	if input: 
		velocity = velocity.move_toward(input * SPEED , delta * ACCELERATION)

	else: 
		velocity = velocity.move_toward(Vector2(0,0), delta * ACCELERATION)


func _physics_process(delta):

	var input = Input.get_vector("ui_left","ui_right","ui_up","ui_down")

	player_movement(input, delta)

	move_and_slide()
		
		
