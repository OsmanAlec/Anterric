extends CharacterBody3D

@onready var anim_tree = get_node("AnimationTree")

func _physics_process(delta: float) -> void:
	
	
	anim_tree.get("parameters/playback").travel("flying idle")

	move_and_slide()
