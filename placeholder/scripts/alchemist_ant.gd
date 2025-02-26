extends CharacterBody3D

@onready var interaction_area: Area3D = $InteractionArea
@onready var InteractionLabel: Label3D = $Label3D

const char_name: String = "George"
var canInteract = false

const prologue: Array[String] = [
	"heyyyyyy",
	"RQUEEN Who are you???",
	"i need coin",
	"RQUEEN for who?",
	"for you..."
]

func _ready() -> void:
	InteractionLabel.hide()
	$AnimatedSprite3D.play("idle")
	DialogManager.finished_talking.connect(_on_finished_talking)

func _unhandled_key_input(event):
	if event.is_action_pressed("advance_dialog"):
		if canInteract:
			InteractionLabel.hide()
			DialogManager.start_dialog(global_position, prologue, char_name)
			
func _on_interaction_area_body_entered(body: Node3D) -> void:
	if body.is_in_group("Player"):
		InteractionLabel.show()
		canInteract = true

func _on_interaction_area_body_exited(body: Node3D) -> void:
	if body.is_in_group("Player"):
		InteractionLabel.hide()
		canInteract = false
		
func _on_finished_talking(cn):
	if cn != char_name:
		return
	QuestControl.get_node("Collect50coins").start_quest()
