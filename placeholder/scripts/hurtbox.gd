class_name HurtBox
extends Area3D

signal  recieved_damage(damage: int)

@export var health: Health

func _ready():
	connect("area_entered", Callable(self, "_on_area_entered"))

func _on_area_entered(hitbox: HitBox) -> void:
	if hitbox != null:
		print("I AM HIT")
		health.health -= hitbox.damage
		recieved_damage.emit(hitbox.damage)
