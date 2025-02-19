class_name pot_break
extends Area3D

# Preload the 3D Coin scene
const Coin = preload("res://scenes/dungeonrooms/components/Coin.tscn") 

var broken = false

func _ready():
	connect("area_entered", Callable(self, "_on_area_entered"))

func _on_area_entered(hitbox: HitBox) -> void:
	if hitbox != null && !broken:
		%Animations.play("break")
		broken = true
		
		# Spawn the coin
		var coin = Coin.instantiate()
		add_child(coin) 
		
		# Position the coin slightly above the pot
		
		coin.global_position = global_position + Vector3(0, 0.5, 0)
