extends GridContainer

# Preload heart textures for different health states.
var heart_full = preload("res://art/UI/heart_1.png")
var heart_empty = preload("res://art/UI/heart_3.png")
var heart_half = preload("res://art/UI/heart_2.png") 
var active_heart: TextureRect
@onready var heart_beat_timer: Timer = $"../heart_beat"

func _ready() -> void:
	# Connect the health_changed signal from the player's Health node.
	get_parent().get_parent().get_node("Health").health_changed.connect(_on_health_changed)
	get_parent().get_parent().get_node("Health").poisoned.connect(_on_poisoned)
	# Initialize the UI by setting the max health and updating the hearts display.
	await update_max_health(PlayerData.max_health)
	update_health(PlayerData.current_health)
	heart_beat_timer.start()

func update_max_health(value):
	# Create and add TextureRect nodes to represent the player's max health.
	for i in value / 2:
		add_child(TextureRect.new()) 
		var heart = get_child(i) 
		heart.texture = heart_full  
		heart.set_expand_mode(5) 
		heart.custom_minimum_size = Vector2(40, 40)
	return

func update_health(value):
	# Update the heart textures based on the player's current health.
	for i in get_child_count():
		if value > i * 2 + 1: 
			get_child(i).texture = heart_full
			active_heart = get_child(i)
		elif value > i * 2:  
			active_heart = get_child(i)
			get_child(i).texture = heart_half
		else:  
			get_child(i).texture = heart_empty

func _on_health_changed(diff: int):
	# Update PlayerData's current health and refresh the heart display.
	await PlayerData.change_health(PlayerData.current_health + diff)
	update_health(PlayerData.current_health)

func _on_poisoned(value: bool):
	if value:
		self.modulate = Color(0, 1, 0, 0.8)
	else:
		self.modulate = Color(1, 1, 1, 1)
		
		
		

func _heart_beat():
	var tween = get_tree().create_tween()
	active_heart.pivot_offset = active_heart.size / 2.0
	# Smoothly scale up the player and move them into position
	tween.tween_property(active_heart, "scale", Vector2(1.2, 1.2), 0.4).set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(active_heart, "scale", Vector2(1, 1), 0.4).set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_IN_OUT)


func _on_heart_beat_timeout() -> void:
	_heart_beat()
