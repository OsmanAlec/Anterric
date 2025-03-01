class_name Health
extends Node


signal max_health_changed(diff:int)
signal health_changed(diff: int)
signal poisoned
signal health_depleted

 # Maximum Health 
@export var max_health: int : set = set_max_health, get = get_max_health
@export var immortality: bool = false : set = set_immortality, get = get_immortality # When player respawns enemy cannot hit for few secs

var immortality_timer: Timer = null
var poison: Array[int] = []
var last_poison_index: int = 0 # index to keep track of poison timing
var current_poison_index: int = 0 #index to keep adding poison to the bounded buffer

@onready var health: int = max_health : set = set_health, get = get_health
@onready var poison_timer: Timer = Timer.new()

func _ready() -> void:
	poison.resize(4)
	poison.fill(0) #initialise poison to 0
	poison_timer.wait_time = 2.0
	poison_timer.connect("timeout", Callable(self, "_on_poison_timer_timeout"))
	add_child(poison_timer)
	if get_parent().is_in_group("Player"):
		max_health = PlayerData.max_health
		health = PlayerData.current_health

func set_max_health(value: int):
	var clamped_value = 1 if value <= 0 else value
	
	if not clamped_value == max_health:
		var difference = clamped_value - max_health
		max_health = value
		max_health_changed.emit(difference)
		
		if health > max_health:
			health = max_health
		
	
	
func get_max_health() -> int:
	return max_health

func set_immortality(value: bool):
	immortality = value

func get_immortality() -> bool:
	return immortality

func set_temporary_immortality(time : float):
	if immortality_timer == null:
		immortality_timer = Timer.new()
		immortality_timer.one_shot = true
		add_child(immortality_timer)
		
	if immortality_timer.timeout.is_connected(set_immortality):
		immortality_timer.timeout.disconnect(set_immortality)
		
	immortality_timer.set_wait_time(time)
	immortality_timer.timeout.connect(set_immortality.bind(false))
	immortality = true
	immortality_timer.start()
	


func set_health(value: int):
	if value < health and immortality:
		return
	
	if health == 0:
		health = value
		return
	
	var clamped_value = clampi(value, 0, max_health)
	
	if clamped_value != health:
		var difference = clamped_value - health
		health = value
		health_changed.emit(difference)
		if health <= 0:
			health_depleted.emit()
			

func get_health():
	return health
	


func apply_poison(damage: int):
	"""Position can stack up 4 times,
	but never more than 4. Update how much poison
	damage is caused in total"""
	if poison[current_poison_index] == 0:
		print("added poison")
		poison[current_poison_index] = damage
		current_poison_index = (current_poison_index + 1) % 4
		print("starting")
		if poison_timer.time_left == 0:
			poison_timer.start()
	else:
		return

func _on_poison_timer_timeout():
	
	if poison.max() == 0:
		poison_timer.stop()
		poisoned.emit(false)
		return
	var total_damage: int = 0
	for dmg in poison:
		total_damage += dmg
	if total_damage:
		health -= total_damage / 2
		poisoned.emit(true)
	if poison[last_poison_index] != 0:
		poison[last_poison_index] = 0
		last_poison_index = (last_poison_index + 1) % 4
		
	
	
