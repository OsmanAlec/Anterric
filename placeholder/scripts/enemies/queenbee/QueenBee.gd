extends CharacterBody3D

@onready var anim_player = $Animations 
@onready var stun_area = $StunArea  
@onready var stomp_timer = $StompTimer  
@onready var ray_cast = $RayCast3D  # Add a RayCast3D to detect ground

var is_stomping = false  # Track if Queen Bee is currently stomping
@export var flying_height: float = 4.0  # Height where Queen Bee flies
@export var ground_offset: float = 0.5  # Small offset from the ground to prevent clipping
@export var descent_speed: float = 2.5  # Speed of descent
@export var ascent_speed: float = 2.0  # Speed of ascent
@export var stomp_interval: float = 8.0  # Time between stomps

func _ready():
	if not anim_player:
		push_error("AnimationPlayer node not found. Check the node path!")
	else:
		anim_player.play("flying")  # Start with flying animation

	stomp_timer.wait_time = stomp_interval
	stomp_timer.start()

	# Debugging: Print initial Queen Bee position
	print("Queen Bee Initial Position:", global_position)

# Detect the ground level using RayCast3D
func get_ground_level() -> float:
	ray_cast.force_raycast_update()
	if ray_cast.is_colliding():
		var ground_y = ray_cast.get_collision_point().y + ground_offset
		print("Ground detected at Y:", ground_y)
		return ground_y
	else:
		print("WARNING: No ground detected! Using fallback ground level.")
		return 0.5  # Default ground level if no collision is detected

# Called when the StompTimer times out 
func _on_stomp_timer_timeout() -> void:
	if anim_player:
		is_stomping = true  # Mark as stomping
		print("Queen Bee preparing to stomp...")
		move_to_ground()  # Move Queen Bee to the ground before stomping

# Move Queen Bee down to the ground before playing the stomp animation
func move_to_ground():
	var ground_position = get_ground_level()  # Get the correct ground position
	print("Moving to ground level:", ground_position)

	var move_time = abs(global_position.y - ground_position) / descent_speed
	var tween = get_tree().create_tween()
	tween.tween_property(self, "global_position:y", ground_position, move_time)
	await tween.finished  # Wait until movement finishes

	print("Queen Bee has landed! Performing stomp...")  # Debug line
	global_position.y = ground_position  
	anim_player.play("stomp")  # Play the stomp animation

	# Check for players already inside the StunArea
	for body in stun_area.get_overlapping_bodies():
		if body.is_in_group("Player"):
			print("Player was already inside StunArea! Stunned!")
			body.apply_stun(2.0)

# Called when an animation finishes 
func _on_animations_animation_finished(anim_name: StringName) -> void:
	if anim_name == "stomp":
		print("Stomp finished, ascending back to flying height...")  # Debug line
		is_stomping = false  # Stomp finished, reset flag
		move_to_air()  # Make Queen Bee return to flying

# Move Queen Bee back to flying height
func move_to_air():
	var move_time = abs(global_position.y - flying_height) / ascent_speed
	var tween = get_tree().create_tween()
	tween.tween_property(self, "global_position:y", flying_height, move_time)
	await tween.finished  # Wait until movement finishes using TWEEN Here

	print("Queen Bee is flying again.")  # Debugging line
	global_position.y = flying_height  # Ensure correct position
	anim_player.play("flying")  # Resume flying animation
	stomp_timer.start()  # Restart the stomp cycle

# Called when a body enters the StunArea 
func _on_stun_area_body_entered(body: Node) -> void:
	print("Something entered StunArea:", body.name)  # Debug Line

	# Check if the body is in the "Player" group and Queen Bee is currently stomping
	if body.is_in_group("Player") and is_stomping:
		print("I am stunned")  # Confirm player stun
		body.apply_stun(2.0)  # Stun the player for 2 seconds
	else:
		print("Not a player or Queen Bee is not stomping, ignoring.")
