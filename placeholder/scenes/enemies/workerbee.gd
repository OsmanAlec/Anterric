extends CharacterBody3D

@onready var anim: AnimatedSprite3D = $Animations

@export var speed: float = 2.0
@export var attack_range: float = 0.5
@export var detection_range: float = 3

@onready var player: CharacterBody3D = get_tree().get_first_node_in_group("Player")

var canAttack = true
var isAttacking = false

func _physics_process(delta):
	if player and global_position.distance_to(player.global_position) <= detection_range:
		if not isAttacking:
			move_towards_player(delta)
		check_attack()
	else:
		if not isAttacking:
			anim.play("fly")

func move_towards_player(delta):
	if global_position.distance_to(player.global_position) > attack_range:
		var direction = (player.global_position - global_position).normalized()
		velocity = direction * speed
		if not isAttacking:
			anim.play("fly")
		if direction.x < 0:
			anim.flip_h = false
		else:
			anim.flip_h = true
		move_and_slide()
	else:
		velocity = Vector3.ZERO

func check_attack():
	if global_position.distance_to(player.global_position) <= attack_range and canAttack:
		isAttacking = true
		anim.play("attack")
		await get_tree().create_timer(0.3).timeout
		attack()

func attack():
	canAttack = false
	$HitBox/CollisionShape3D.disabled = false
	await get_tree().create_timer(0.5).timeout
	$HitBox/CollisionShape3D.disabled = true
	isAttacking = false

signal died  # Signal to notify when an enemy dies

func die():
	print("Enemy died!")
	died.emit()  # Notify the Enemies node
	queue_free()  # Remove the enemy from the scene

func _on_attack_cooldown_timeout() -> void:
	canAttack = true

func _on_health_health_depleted() -> void:
	died.emit()  # Notify the parent node
	print("enemiy dead")
	queue_free()


func _on_animations_animation_finished() -> void:
	if anim.animation == "attack":
		$attack_cooldown.start()
		anim.play("fly")
		
