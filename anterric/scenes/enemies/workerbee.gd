extends CharacterBody3D

@onready var anim: AnimatedSprite3D = $Animations

@export var speed: float = 2.0
@export var attack_range: float = 0.5
@export var detection_range: float = 1.7
@export var drop_item1: invitem2
@export var drop_item2: invitem2


@onready var player: CharacterBody3D = get_tree().get_first_node_in_group("Player")

var pickup_scene: PackedScene = preload("res://inventory/items/item.tscn")
var HEART_SCENE = load("res://scenes/dungeonrooms/heart.tscn")

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
	died.emit()  # Notify the Enemies node
	queue_free()  # Remove the enemy from the scene

func _on_attack_cooldown_timeout() -> void:
	canAttack = true

func _on_health_health_depleted() -> void:
	died.emit()  # Notify the parent node
	
	if randf() < 0.9:
		#40% chance to spawn nectar
		if randf() < 0.4:
			var pickup = pickup_scene.instantiate() as Node3D
			pickup.resource = drop_item1
			pickup.global_position = global_position
			get_tree().current_scene.add_child(pickup)	
		else:
			var pickup = pickup_scene.instantiate() as Node3D
			pickup.resource = drop_item2
			pickup.global_position = global_position
			get_tree().current_scene.add_child(pickup)
	# 50% chance to spawn a heart.
	if randf() < 0.5:
		var heart_instance = HEART_SCENE.instantiate()
		heart_instance.global_position = global_position
		
		# 20/80 chance for full/half heart.
		if randf() < 0.2:
			heart_instance.set_heart_type("full")
		else:
			heart_instance.set_heart_type("half")
		
		get_tree().current_scene.add_child(heart_instance)
	queue_free()


func _on_animations_animation_finished() -> void:
	if anim.animation == "attack":
		$attack_cooldown.start()
		anim.play("fly")
		
