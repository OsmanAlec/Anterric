extends GridContainer

# Preload heart textures for different health states.
var heart_full = preload("res://art/UI/heart_1.png")
var heart_empty = preload("res://art/UI/heart_3.png")
var heart_half = preload("res://art/UI/heart_2.png") 
var poisoned_full = preload("res://art/UI/poisonedheart_1.png")
var poisoned_empty = preload("res://art/UI/poisonedheart_3.png")
var poisoned_half = preload("res://art/UI/poisonedheart_2.png") 
var active_heart: TextureRect
@onready var heart_beat_timer: Timer = PlayerManager.get_node("HUD/heart_beat")

func _ready() -> void:
	# Initialize the UI by setting the max health and updating the hearts display.
	heart_beat_timer.start()

func update_max_health(value):
	# Create and add TextureRect nodes to represent the player's max health.
	for child in get_children():
		child.queue_free()
	for i in value / 2:
		add_child(TextureRect.new()) 
		var heart: TextureRect = get_child(i) 
		heart.texture = heart_full  
		heart.set_expand_mode(5) 
		heart.custom_minimum_size = Vector2(32, 32)
		active_heart = heart
	#for some reason need to wait, the canvas does not draw fast enough
	await get_tree().create_timer(0.5).timeout 
	update_health(PlayerData.current_health)
	return

func draw_poison(value):
	for i in get_child_count():
		if value > i * 2 + 1: 
			get_child(i).texture = poisoned_full
			active_heart = get_child(i)
		elif value > i * 2:  
			active_heart = get_child(i)
			get_child(i).texture = poisoned_half
		else:  
			get_child(i).texture = poisoned_empty
	

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

func _heart_beat():
	var tween = get_tree().create_tween()
	if !active_heart:
		return #sometimes the active heart doesnt load in quick enough.
	active_heart.pivot_offset = active_heart.size / 2.0
	# Smoothly scale up the player and move them into position
	tween.tween_property(active_heart, "scale", Vector2(1.2, 1.2), 0.4).set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(active_heart, "scale", Vector2(1, 1), 0.4).set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_IN_OUT)


func _on_heart_beat_timeout() -> void:
	_heart_beat()
