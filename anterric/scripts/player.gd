extends CharacterBody3D

# Movement and action constants
const RATE = 1.5
const SPEED = 3 * RATE
const ACCELERATION = 30 * RATE
const DASH_SPEED = 6 * RATE

# State variables
var dashing = false
var canDash = true
var currentAttack = false
var canAttack = true
var state: String = "Idle"
var lastDir: Vector3
# Stun Mechanism
var canMove: bool = true

@onready var sfx_walk = $AudioStreamPlayer3D
@onready var anim_tree = get_node("AnimationTree")
@export var inv:  maininv
 

func _ready() -> void:
	$HitLeft/CollisionShape3D.disabled = true
	$HitRight/CollisionShape3D.disabled = true
	
	var tween = get_tree().create_tween()
	# Start with the player invisible and tiny
	scale = Vector3(5, 5, 5)  # Make the player tiny
	
	# Smoothly scale up the player and move them into position
	tween.tween_property(self, "scale", Vector3(1, 1, 1), 0.4).set_ease(Tween.EASE_OUT)
	
	

	# Handles player movement logic
func player_movement(delta: float):
	# Determine movement direction
	var input_dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var direction = Vector3(input_dir.x, 0, input_dir.y)
	
	direction = direction.normalized()
	# Handle dashing
	if Input.is_action_just_pressed("dash") and canDash:
		dashing = true
		canDash = false
		$dash_timer.start()
		$dash_again_timer.start()
		GameManager.sfx_dash.play()
	
	# If player is moving
	if direction:
		
		lastDir = direction# Store latest movement direction
		if dashing:
			state = "Dashing"
			velocity = velocity.move_toward(direction * DASH_SPEED, delta * ACCELERATION)
			anim_tree.get("parameters/playback").travel("Dashing")
			anim_tree.set("parameters/Dashing/BlendSpace1D/blend_position", lastDir.x)
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
			
# Called every physics frame
func _physics_process(delta: float):
	
	if !canMove:
		anim_tree.get("parameters/playback").travel("Standing")
		anim_tree.set("parameters/Standing/BlendSpace1D/blend_position", lastDir.x)
		return
	
	# Handle attack input
	if Input.is_action_just_pressed("primary_attack"):
		if canAttack and state != "Dashing":
			start_attack()
	
	# Process movement after animation has played
	player_movement(delta)
	move_and_slide()
	
	

# Start attack sequence
func start_attack():
	currentAttack = true
	canAttack = false
	anim_tree.get("parameters/playback").travel("Attack")
	anim_tree.set("parameters/Attack/BlendSpace2D/blend_position", Vector2(lastDir.x, velocity.length()))
	if lastDir.x <= 0:
		$HitLeft/CollisionShape3D.disabled = false
	else:
		$HitRight/CollisionShape3D.disabled = false
	$attack_timer.start()
	


func _on_dash_timer_timeout() -> void:
	dashing = false
	$HitLeft/CollisionShape3D.disabled = true
	$HitRight/CollisionShape3D.disabled = true
		

func _on_dash_again_timer_timeout() -> void:
	canDash = true
	


# Reset attack state after attack animation ends
func _on_animation_tree_animation_started(anim_name: StringName) -> void:
	if "Attack" not in anim_name:
		currentAttack = false
		$HitLeft/CollisionShape3D.disabled = true
		$HitRight/CollisionShape3D.disabled = true
		
# Reset after attack timer ends	
func _on_attack_timer_timeout() -> void:
	canAttack = true
	currentAttack = false
	$HitLeft/CollisionShape3D.disabled = true
	$HitRight/CollisionShape3D.disabled = true
		

# Handle player death
func _on_health_health_depleted() -> void:
	get_tree().change_scene_to_file("res://scenes/UI/gameover.tscn")

func apply_stun(duration: float) -> void:
	canMove = false
	await get_tree().create_timer(duration).timeout         
	canMove = true

func collect(item):
	inv.insert(item)
	
func _on_update():
	print("received update?")
	
