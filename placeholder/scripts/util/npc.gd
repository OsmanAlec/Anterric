extends CharacterBody3D

@onready var interaction_area: Area3D = $InteractionArea
@onready var InteractionLabel: Label3D = $Label3D

var canInteract = false

func _ready() -> void:
	InteractionLabel.hide()

const lines: Array[String] = [
	"OMG I LOVE YOUR GAME!!",
	"Wait, I should probably introduce myself.",
	"I'm an invisible NPC, isn't that crAaAZzY?",
	"Anywho....",
	"I'm so glad this works!!!",
]

func _unhandled_key_input(event):
	if event.is_action_pressed("advance_dialog"):
		if canInteract:
			InteractionLabel.hide()
			DialogManager.start_dialog(global_position, lines)
			
func _on_interaction_area_body_entered(body: Node3D) -> void:
	if body.is_in_group("Player"):
		InteractionLabel.show()
		canInteract = true
		
func _on_interaction_area_body_exited(body: Node3D) -> void:
	if body.is_in_group("Player"):
		InteractionLabel.hide()
		canInteract = false
