extends CharacterBody3D

@onready var interaction_area: Area3D = $InteractionArea
@onready var InteractionLabel: Label3D = $Label3D


const lines: Array[String] = [
	"OMG I LOVE YOUR GAME!!",
	"Wait, I should probably introduce myself.",
	"I'm an invisible NPC, isn't that crAaAZzY?aaaaaaaaaaaa",
	"OMG I LOVE YOUR GAME!!",
	"I'm an invisible NPC, isn't that crAaAZzY?",
	"OMG I LOVE YOUR GAME!!",
	"Wait, I should probably introduce myself.",
	"Wait, I should probably introduce myself.",
]

func _unhandled_key_input(event):
	if event.is_action_pressed("advance_dialog"):
		if interaction_area.overlaps_body($Player):
			InteractionLabel.hide()
			DialogManager.start_dialog(global_position, lines)
			

	
func _on_interaction_area_body_exited(body):
	InteractionLabel.hide()


func _on_interaction_area_area_entered(area: Area3D) -> void:
	print("HEYYY")
