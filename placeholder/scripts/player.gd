extends CharacterBody3D

const RATE = 3
const SPEED = 4 * RATE
const ACCELERATION = 25 * RATE

func player_movement(direction, delta):

	if direction: 
		velocity = velocity.move_toward(direction * SPEED, delta * ACCELERATION)

	else: 
		velocity = velocity.move_toward(Vector3.ZERO, delta * ACCELERATION)


func _physics_process(delta):

	var direction = Vector3.ZERO

	if Input.is_action_pressed("ui_right"):
		direction.x += 1
	if Input.is_action_pressed("ui_left"):
		direction.x -= 1
	if Input.is_action_pressed("ui_down"):
		direction.z += 1
	if Input.is_action_pressed("ui_up"):
		direction.z -= 1

	player_movement(direction, delta)

	move_and_slide()
		
		
