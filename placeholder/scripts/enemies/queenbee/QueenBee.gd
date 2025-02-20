extends CharacterBody3D

@export var speed: float = 2.0  # Speed of descent
@export var ground_height: float = 0.5  # Height where the bee stops descending

@onready var stun_timer = $StunTimer  # Timer for stun duration
@onready var start_position = global_transform.origin  # Starting position
@onready var stun_area = $StunArea  # Stun area to detect collisions

var descending: bool = true  # Bee starts by descending

func _process(delta):
	$Animations.play("stomp")
	$Animations.play("flying")
	$Animations.play("takeoff")
	$Animations.play("sting")
	
	
	

func _on_StunArea_body_entered(body):
	if body.is_in_group("Player"):  # Check if the colliding body is the ant
		print("I AM STUNNED")  # Console log when stunned
		body.freeze = true  # Freeze the ant
		stun_timer.start()  # Start stun timer

func _on_StunTimer_timeout():
	print("Stun ended")  # Console log when stun effect ends
	var bodies = stun_area.get_overlapping_bodies()
	for body in bodies:
		if body.is_in_group("Player"):
			body.freeze = false  # Unfreeze the ant
