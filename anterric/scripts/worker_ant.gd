extends CharacterBody3D

@onready var interaction_area: Area3D = $InteractionArea
@onready var InteractionLabel: Label3D = $InteractionLabel


var canInteract = false
var talking = false
const char_name = "Erric"


@onready var quests: Array[Quest] = [
	QuestControl.get_node("Grass"),
	QuestControl.get_node("Gather5Lime"),
	QuestControl.get_node("WorkerFood"),
	QuestControl.get_node("Slay The Queen Bee")
]

const prologue: Array[String] = [
	"Our colony, your majesty, it's in ruins!",
	"RQUEEN What do you mean?",
	"We've ran out of resources,",
	"the storm damaged our tunnels,",
	"and those termites are destorying the tree!",
	"RQUEEN Well, how can I help?",
	"Go out there, deal with their brainwashed army,",
	"and return with some grass!"
]

const prologue_questComplete: Array[String] = [
	"Thank you, your majesty",
	"This will be of much help!",
	"RQUEEN No problem, Erric."
]

const level1: Array[String] = [
	"RQUEEN Erric, the nest feels... exposed.",
	"The Queen’s chamber is vulnerable.",
	"We need lime to harden the walls.",
	"RQUEEN Lime? Where do I get that?",
	"I've seen the ticks carrying it.",
	"Bring me 5 pieces.",
	"RQUEEN On it."
]

const level1_questComplete: Array[String] = [
	"The walls will hold now, your Majesty.",
	"RQUEEN I feel safer already.",
	"As you should. But safety is only temporary.",
	"RQUEEN We’ll be ready for whatever comes next.",
	"Here's an extra heart!"
]

const level2: Array[String] = [
	"The bees have grown too bold, my Queen.",
	"RQUEEN I know. They won’t stop until we stop them.",
	"We must reinforce the outer tunnels.",
	"The workers are hungry.",
	"RQUEEN I’ll gather what’s needed.",
	"Good. Then, we fight."
]

const level2_questComplete: Array[String] = [
	"The defenses are strong.",
	"The colony stands firmer than ever.",
	"RQUEEN Now onto the bee queen",
	"The colony thanks you,",
	"We give you extra strength"
]

const queenbeeboss: Array[String] = [
	"The time has come.",
	"Get rid of the Bee Queen,",
	"and we may live in peace",
	"RQUEEN After we deal with termites too",
	"Oh right, yeah them too"
]

const queenbeeboss_questComplete: Array[String] = [
	"I am so proud your Majesty!",
	"RQUEEN Thank you, Erric!",
]

# A dictionary to keep track of the dialogues dynamically according to the stage the player is at
var dialogs: Dictionary = {
	"prologue": prologue,
	"prologue_questComplete": prologue_questComplete,
	"level1": level1,
	"level1_questComplete": level1_questComplete,
	"level2": level2,
	"level2_questComplete": level2_questComplete,
	"queenbeeboss": queenbeeboss,
	"queenbeeboss_questComplete": queenbeeboss_questComplete,
}

func _ready() -> void:
	InteractionLabel.hide()
	DialogManager.finished_talking.connect(_on_finished_talking)
	$AnimatedSprite3D.play("idle")

	
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("advance_dialog"):
		if canInteract:
			$AnimatedSprite3D.play("talking")
			var key: String = GameManager.Stage[GameManager.current_stage]
			InteractionLabel.hide()
			if quests[GameManager.current_stage].quest_status == Quest.QuestStatus.reached_goal:
				key += "_questComplete"
			DialogManager.start_dialog(global_position, dialogs[key], char_name)
	
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

	var key: String = GameManager.Stage[GameManager.current_stage]
	
	if quests[GameManager.current_stage].quest_status == Quest.QuestStatus.reached_goal:
		quests[GameManager.current_stage].finish_quest()
	elif quests[GameManager.current_stage].quest_status == Quest.QuestStatus.available:
		quests[GameManager.current_stage].start_quest()
