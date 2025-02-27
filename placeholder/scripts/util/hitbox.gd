class_name HitBox
extends Area3D

enum Types {
	physical,
	poison,
}

@export var damage: int = 1 : set = set_damage, get = get_damage
@export var type: Types = Types.physical


func set_damage(value: int):
	damage = value
	
func get_damage() -> int:
	return damage
	
