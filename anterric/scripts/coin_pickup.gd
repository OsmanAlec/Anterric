extends Area3D


signal coin_pickedup

@export var coin: invitem2
@onready var player = get_tree().get_first_node_in_group("Player")
var speed = 0.25

func _on_body_entered(body: Node3D) -> void:
	if player == body:
		coin_pickedup.emit()

func _process(delta: float) -> void:
	var target_pos = PlayerData.player.global_position
	target_pos.y += 0.5
	get_parent().global_position = get_parent().global_position.lerp(target_pos, speed * delta)
	speed += 0.25 #create an ease in function
