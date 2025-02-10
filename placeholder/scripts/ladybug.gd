extends CharacterBody3D

@export var player_path: NodePath  # Follows the ant from world scene
const SPEED: float = 5.0

@export var detection_radius: float = 4.0  # Detection range for flying
@export var stopping_distance: float = 3.0  # Maintain distance when following
@export var flying_height: float = 0.4  # Target height when flying
@export var ascent_speed: float = 0.5  # Speed of flying up

@onready var anim_tree = get_node("AnimationTree")

var isFlying: bool = false  # Tracks if ladybug is flying
var flight_progress: float = 0.0  # Smooth flight transition
var canAttack = true

func _physics_process(delta: float) -> void:
    var player = get_node(player_path)
    var direction = 0
    
    if player:
        var distance = global_transform.origin.distance_to(player.global_transform.origin)


        # If the ant enters the detection radius, the ladybug takes off
        if distance < detection_radius and not isFlying:
            isFlying = true  # Enable flying mode
            anim_tree.get("parameters/playback").travel("takeoff")
            anim_tree.set("parameters/flying idle/BlendSpace2D/blend_position", direction) 

        if isFlying:
            # increase Y position to simulate flying using lerp
            flight_progress = min(flight_progress + ascent_speed * delta, 1.0)
            global_transform.origin.y = lerp(global_transform.origin.y, flying_height, flight_progress)
            direction = (player.global_transform.origin - global_transform.origin).normalized()
            
            # Follow player, but maintain stopping distance
            if distance > stopping_distance:
                velocity = velocity.lerp(direction * SPEED, delta * 5)
                anim_tree.get("parameters/playback").travel("flying moving")
                anim_tree.set("parameters/flying moving/BlendSpace2D/blend_position", direction) 
            else:
                velocity = Vector3.ZERO  # Stop if too close
                if canAttack:
                    $attack_timer.start()
                    canAttack = false
                    print(direction.x)
                    anim_tree.get("parameters/playback").travel("attack")
                    anim_tree.set("parameters/attack/BlendSpace2D/blend_position", Vector2(direction.x, 0)) 
                else:
                    anim_tree.get("parameters/playback").travel("flying idle")
                    anim_tree.set("parameters/flying idle/BlendSpace2D/blend_position", Vector2(direction.x, 0))
        else:
            # Idle when not flying
            velocity = Vector3.ZERO
            anim_tree.get("parameters/playback").travel("ground idle")
            anim_tree.set("parameters/flying idle/BlendSpace2D/blend_position", direction) 
            
    else:
        velocity = Vector3.ZERO  # Stop moving if player is null 
    
    move_and_slide()


func _on_attack_timer_timeout() -> void:
    canAttack = true
