extends CharacterBody3D

@onready var interaction_area: Area3D = $InteractionArea
@onready var InteractionLabel: Label3D = $Label3D

var canInteract = false
var talking = false
const char_name = "SuperMajor"


const prologue: Array[String] = [
	"Your Majesty.",
	"RQUEEN ...",
	"...",
	"RQUEEN ?",
	"Oh, uhh-",
	"Termites- bad deal, tree is falling",
	"Our soldiers are starving",
	"We need to build an army."
]

const level1: Array[String] = [
	"OMG I LOVE YOUR GAME!!",
	"Wait, I should probably introduce myself.",
	"I'm an invisible NPC, isn't that crAaAZzY?",
	"Anywho....",
	"I'm so glad this works!!!",
]

func _ready() -> void:
	InteractionLabel.hide()
	DialogManager.finished_talking.connect(_on_finished_talking)
	$AnimatedSprite3D.play("idle")

	
func _unhandled_key_input(event):
	if event.is_action_pressed("advance_dialog"):
		if canInteract:
			InteractionLabel.hide()
			DialogManager.start_dialog(global_position, prologue, char_name)
			$AnimatedSprite3D.play("talking")
	
func _on_interaction_area_body_entered(body: Node3D) -> void:
	if body.is_in_group("Player"):
		InteractionLabel.show()
		canInteract = true

func _on_interaction_area_body_exited(body: Node3D) -> void:
	if body.is_in_group("Player"):
		InteractionLabel.hide()
		canInteract = false


func _on_finished_talking(cn) -> void:
	if cn != char_name:
		return
	$AnimatedSprite3D.play("idle")
