extends CharacterBody3D

const RATE = 1.5
const SPEED = 4 * RATE
const ACCELERATION = 30 * RATE
const DASH_SPEED = 7 * RATE
var dashing = false
var canDash = true
var currentAttack = false

func player_movement(direction, delta):
	
	
	if Input.is_action_just_pressed("dash") and canDash:
		dashing = true
		canDash = false
		$dash_timer.start()
		$dash_again_timer.start()

	if direction: 
		if dashing:
			velocity = velocity.move_toward(direction * DASH_SPEED, delta * ACCELERATION)
		else:
			velocity = velocity.move_toward(direction * SPEED, delta * ACCELERATION)

	else: 
		velocity = velocity.move_toward(Vector3.ZERO, delta * ACCELERATION)
	


func _physics_process(delta):

	var direction = Vector3.ZERO
	var facingDir: String = "right"

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
	
	if !currentAttack:
		currentAttack = true
		if Input.is_action_just_pressed("primary_attack"):
			#Animation.play("primary_attack" + facingDir)
			pass
					
		
		
	
	if abs($Camera_Controller.position.x - position.x) > 0.5:
		$Camera_Controller.position.x = lerp($Camera_Controller.position.x, position.x, 0.1 * RATE)
	if $Camera_Controller.position.z - position.z != 0:
		$Camera_Controller.position.z = lerp($Camera_Controller.position.z, position.z, 0.1 * RATE)
		
	
	
		
		


func _on_dash_timer_timeout() -> void:
	dashing = false

func _on_dash_again_timer_timeout() -> void:
	canDash = true
