extends CharacterBody3D

@onready var anim_player = $Animations 
@onready var stun_area = $StunArea  

func _ready():
	if not anim_player:
		push_error("AnimationPlayer node not found. Check the node path!")
	else:
		anim_player.play("flying")  # Play flying animation at the start

# Called when the StompTimer times out 
func _on_stomp_timer_timeout() -> void:
	if anim_player:
		anim_player.play("stomp")

# Called when an animation finishes 
func _on_animations_animation_finished(anim_name: StringName) -> void:
	if anim_name == "stomp":
		anim_player.play("flying")  # After stomp, return to flying

# Called when a body enters the StunArea HOWEVER DOESNT PRINT I AM STUNNED
func _on_stun_area_body_entered(body: Node) -> void:
	print("Something entered StunArea:", body.name)  # Debugging line



	# Check if the body is in the "player" group
	if body.is_in_group("Player"):
		print("I am stunned")  # Confirm player stun
		body.apply_stun(2.0)  # Stun the player for 2 seconds
	else:
		print("Not a player, ignoring.")
