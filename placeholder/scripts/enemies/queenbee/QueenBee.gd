extends CharacterBody3D

@onready var anim_player = $AnimationPlayer
@onready var stun_area = $StunArea  
@onready var stomp_timer = $StompTimer 
@onready var player: CharacterBody3D = PlayerData.player
@onready var HealthBar: ProgressBar = $HealthBar
const attack_range: float = 1.5
var is_stomping = false  # Track if Queen Bee is currently stomping
var can_stomp = false
const flying_height: float = 2.5  # Height where Queen Bee flies
const ground: float = 1.4  # Small offset from the ground to prevent clipping
const speed: float = 2.0

var canSting = true
var isStinging = false

func _ready():
	HealthBar.value = $Health.health
	anim_player.current_animation = "fly"  # Start with flying animation
	stomp_timer.start()

func _physics_process(delta):
	
	if can_stomp:
		#go_to_stomp() this function will get one of the random markers, go to it and stomp
		stomp_ground()
		return
	elif is_stomping:
		return
	
	move_towards_player(delta)
	check_attack()
	

# Called when the StompTimer times out 
func _on_stomp_timer_timeout() -> void:
	can_stomp = true

# Move Queen Bee down to the ground before playing the stomp animation
func stomp_ground():
	can_stomp = false
	is_stomping = true
	var tween = get_tree().create_tween()
	tween.tween_property($StunArea/CollisionShape3D/StompIndicator, "transparency", 0.9, 0.25).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_EXPO)
	tween.tween_property($StunArea/CollisionShape3D/StompIndicator, "transparency", 1, 0.25).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_EXPO)
	tween.tween_property($StunArea/CollisionShape3D/StompIndicator, "transparency", 0.8, 0.5).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_EXPO)
	tween.tween_property($StunArea/CollisionShape3D/StompIndicator, "transparency", 1, 0.25).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_EXPO)

	tween.tween_property(self, "global_position", Vector3(position.x, ground, position.z), 0.7).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)
	await get_tree().create_timer(1.5).timeout
	print("finished warning")

	anim_player.current_animation = "stomp"  # Play the stomp animation

	# Check for players already inside the StunArea
	if (player in stun_area.get_overlapping_bodies()) and !player.dashing:
		print("stunned")
		player.apply_stun(1.0)


# Move Queen Bee back to flying height
func move_to_air():
	var tween = get_tree().create_tween()
	tween.tween_property(self, "global_position", Vector3(position.x, flying_height, position.z), 0.5).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_EXPO)

	anim_player.current_animation = "takeoff"  # Resume flying animation
	stomp_timer.start()  # Restart the stomp cycle


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if "stomp" in anim_name:
		is_stomping = false  # Stomp finished, reset flag
		move_to_air()  # Make Queen Bee return to flying
	if "takeoff" in anim_name or "sting" in anim_name:
		anim_player.current_animation = "fly"
		

func move_towards_player(delta):
	if global_position.distance_to(player.global_position) > attack_range:
		var direction = (player.global_position - global_position).normalized()
		velocity = direction * speed
		if direction.x >= 0:
			%Animations.flip_h = true
		else:
			%Animations.flip_h = false
		move_and_slide()
	else:
		velocity = Vector3.ZERO

func check_attack():
	if global_position.distance_to(player.global_position) <= attack_range and canSting:
		isStinging = true
		anim_player.current_animation = "sting"
		await get_tree().create_timer(0.4).timeout
		attack()

func attack():
	canSting = false
	$HitBox/CollisionShape3D.disabled = false
	await get_tree().create_timer(0.5).timeout
	$HitBox/CollisionShape3D.disabled = true
	$StingTimer.start()
	isStinging = false
	anim_player.current_animation = "fly"

func _on_sting_timer_timeout() -> void:
	canSting = true
	


func _on_health_health_depleted() -> void:
	queue_free()


func _on_health_health_changed(diff: int) -> void:
	var tween = get_tree().create_tween()
	tween.tween_property(HealthBar, "modulate", Color(0, 0, 0, 0.9), 0.1).set_trans(Tween.TRANS_BOUNCE)
	tween.tween_property(HealthBar, "rotation", 0.1, 0.1).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_ELASTIC)
	tween.tween_property(HealthBar, "rotation", -0.1, 0.1).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_ELASTIC)
	tween.tween_property(HealthBar, "modulate", Color(1, 1, 1, 1), 0.1).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_BOUNCE)
	tween.tween_property(HealthBar, "rotation", 0, 0.1).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_ELASTIC)

	HealthBar.value = $Health.health
