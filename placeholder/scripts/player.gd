extends CharacterBody3D

# Inventory 
@export var inv: = Inv

# Movement and action constants
const RATE = 1.5
const SPEED = 3 * RATE
const ACCELERATION = 30 * RATE
const DASH_SPEED = 6 * RATE

# State variables
var dashing = false
var canDash = true
var currentAttack = false
var state: String = "Idle"
var lastDir: Vector3

@onready var anim_tree = get_node("AnimationTree")

# Handles player movement logic
func player_movement(direction: Vector3, delta: float):
	# Handle dashing
	if Input.is_action_just_pressed("dash") and canDash:
		dashing = true
		canDash = false
		$dash_timer.start()
		$dash_again_timer.start()

	# If player is moving
	if direction:
		lastDir = direction.normalized() # Store latest movement direction
		if dashing:
			state = "Dashing"
			velocity = velocity.move_toward(direction * DASH_SPEED, delta * ACCELERATION)
		else:
			state = "Walking"
			velocity = velocity.move_toward(direction * SPEED, delta * ACCELERATION)
			if !currentAttack:
				anim_tree.get("parameters/playback").travel("Walking")
				anim_tree.set("parameters/Walking/BlendSpace1D/blend_position", lastDir.x)
	# If player is not moving
	else:
		state = "Standing"
		velocity = velocity.move_toward(Vector3.ZERO, delta * ACCELERATION)
		if !currentAttack:
			anim_tree.get("parameters/playback").travel("Standing")
			anim_tree.set("parameters/Standing/BlendSpace1D/blend_position", lastDir.x)

func _ready() -> void:
	$HitLeft.collision_layer = 0
	$HitRight.collision_layer = 0
	
# Called every physics frame
func _physics_process(delta: float):
	
	# Determine movement direction
	var direction: Vector3
	if Input.is_action_pressed("ui_right"):
		direction.x += 1
	if Input.is_action_pressed("ui_left"):
		direction.x -= 1
	if Input.is_action_pressed("ui_down"):
		direction.z += 1
	if Input.is_action_pressed("ui_up"):
		direction.z -= 1

	direction = direction.normalized()

	# Handle attack input
	if Input.is_action_just_pressed("primary_attack"):
		if !currentAttack and state != "Dashing":
			start_attack()
	else:
		$HitLeft.collision_layer = 0
		$HitRight.collision_layer = 0
		
	# Process movement after animation has played
	player_movement(direction, delta)
	move_and_slide()

# Start attack sequence
func start_attack():
	currentAttack = true
	anim_tree.get("parameters/playback").travel(state + " Attack")
	anim_tree.set("parameters/" + state + " Attack/BlendSpace1D/blend_position", lastDir.x)
	print($HitLeft.collision_layer)
	print($HitRight.collision_layer)
	$attack_timer.start()


# Dash ability cooldown
func _on_dash_timer_timeout() -> void:
	dashing = false

func _on_dash_again_timer_timeout() -> void:
	canDash = true

# Reset attack state after attack timer ends
func _on_attack_timer_timeout() -> void:
	$HitLeft.collision_layer = 0
	$HitRight.collision_layer = 0
	currentAttack = false


# Handle player death
func _on_health_health_depleted() -> void:
	queue_free()
