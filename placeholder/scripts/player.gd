extends CharacterBody3D

const RATE = 1.5
const SPEED = 4 * RATE
const ACCELERATION = 30 * RATE
const DASH_SPEED = 7 * RATE
var dashing = false
var canDash = true
var currentAttack = false
var state:String = "Idle"
var lastDir: Vector3

@onready var anim_tree = get_node("AnimationTree")

func player_movement(direction, delta):
	
	
	if Input.is_action_just_pressed("dash") and canDash:
		dashing = true
		canDash = false
		$dash_timer.start()
		$dash_again_timer.start()

	if direction: 
		lastDir = direction
		if dashing:
			state = "Dashing"
			velocity = velocity.move_toward(direction.normalized() * DASH_SPEED, delta * ACCELERATION)
		else:
			state = "Walking"
			velocity = velocity.move_toward(direction.normalized() * SPEED, delta * ACCELERATION)
			if !currentAttack:
				anim_tree.get("parameters/playback").travel("Walking")
				anim_tree.set("parameters/Walking/BlendSpace1D/blend_position", direction.x) 
	else: 
		state = "Standing"
		velocity = velocity.move_toward(Vector3.ZERO, delta * ACCELERATION)
		if !currentAttack:
			anim_tree.get("parameters/playback").travel("Standing")
			anim_tree.set("parameters/Standing/BlendSpace1D/blend_position", lastDir.x) 


func _physics_process(delta):
	
	$HitBox.set_process(false)

	var direction : Vector3

	if Input.is_action_pressed("ui_right"):
		direction.x += 1 
	if Input.is_action_pressed("ui_left"):
		direction.x -= 1
	if Input.is_action_pressed("ui_down"):
		direction.z += 1
	if Input.is_action_pressed("ui_up"):
		direction.z -= 1
	
	direction.normalized()

	player_movement(direction, delta)

	move_and_slide()
	
	if Input.is_action_just_pressed("primary_attack"):
		if !currentAttack and state != "Dashing":
			currentAttack = true
			anim_tree.get("parameters/playback").travel(state + " Attack")
			anim_tree.set("parameters/" + state + " Attack/BlendSpace1D/blend_position", lastDir.x) 
			if lastDir.x > 0:
				$HitBox/Right.set_process(true)
			else:
				$HitBox/Left.set_process(true)
				
			$attack_timer.start()
		
		
	###Controls for the camera
	
	#add a 'dead-zone' to prevent camera flicking
	if abs($Camera_Controller.position.x - position.x) > 0.5:
		$Camera_Controller.position.x = lerp($Camera_Controller.position.x, position.x, 0.05 * RATE)
	#Always prevent player from walking off screen
	if $Camera_Controller.position.z - position.z != 0:
		$Camera_Controller.position.z = lerp($Camera_Controller.position.z, position.z, 0.05 * RATE)
		
	
	



func _on_dash_timer_timeout() -> void:
	dashing = false

func _on_dash_again_timer_timeout() -> void:
	canDash = true

func _on_attack_timer_timeout() -> void:
	currentAttack = false
