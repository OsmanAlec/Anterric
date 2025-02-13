extends CharacterBody3D

@onready var interaction_area: Area3D = $InteractionArea
@onready var InteractionLabel: Label = $Label

const lines: Array[String] = [
	"OMG I LOVE YOUR GAME!!",
	"Wait, I should probably introduce myself.",
	"I'm an invisible NPC, isn't that crAaAZzY?",
]

func _unhandled_input(event):
	if event.is_action_pressed("advance_dialog"):
		if interaction_area.get_overlapping_bodies().size() > 0:
			InteractionLabel.hide()
			DialogManager.start_dialog(Vector2(global_position.x, global_position.y), lines)
			
func _on_interaction_area_body_entered(body):
	InteractionLabel.show()
	
func _on_interaction_area_body_exited(body):
	InteractionLabel.hide()
