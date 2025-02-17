extends Resource 
class_name Quest

@export var title: String = "New Quest"
@export var description: String = "Complete the task."
@export var is_completed: bool = false
@export var objectives: Array[String] = []
@export var reward: String = "Gold"
