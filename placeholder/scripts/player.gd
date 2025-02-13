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
	
	$HitRight.set_process_mode(Node.PROCESS_MODE_DISABLED)
	$HitLeft.set_process_mode(Node.PROCESS_MODE_DISABLED)

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
				$HitRight.set_process_mode(Node.PROCESS_MODE_INHERIT)
			else:
				$HitLeft.set_process_mode(Node.PROCESS_MODE_INHERIT)
				
			$attack_timer.start()
		
		


func _on_dash_timer_timeout() -> void:
	dashing = false

func _on_dash_again_timer_timeout() -> void:
	canDash = true

func _on_attack_timer_timeout() -> void:
	$HitRight.set_process_mode(Node.PROCESS_MODE_DISABLED)
	$HitLeft.set_process_mode(Node.PROCESS_MODE_DISABLED)
	currentAttack = false
