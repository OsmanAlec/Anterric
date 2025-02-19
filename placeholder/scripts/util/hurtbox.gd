class_name HurtBox
extends Area3D

signal  recieved_damage(damage: int)

@onready var sprite = %Animations #access animations3D no matter what the entity structure looks like
@export var health: Health

var dmg_indicator = preload("res://scenes/UI/damage_indicator.tscn").instantiate()

func _ready():
	connect("area_entered", Callable(self, "_on_area_entered"))

func _on_area_entered(hitbox: HitBox) -> void:
	"""When a hurtbox node enters the area of the hitbox,
	take away whatever is set in the hitbox node's damage,
	change the colour on the sprite and spawn damage indicators."""
	if hitbox != null && !health.get_immortality():
		
		#Take damage
		health.health -= hitbox.damage
		recieved_damage.emit(hitbox.damage)
		
		#spawn damage indicator
		var dmg_indicator = load("res://scenes/UI/damage_indicator.tscn").instantiate()
		get_tree().current_scene.add_child(dmg_indicator)
		dmg_indicator.global_position = global_position
		dmg_indicator.label.text = str(hitbox.damage)
		
				
		#Color logic
		sprite.modulate = Color(1, 0, 0)
		await get_tree().create_timer(0.2).timeout
		sprite.modulate = Color(1, 1, 1)
