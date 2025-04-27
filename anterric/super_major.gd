extends CharacterBody3D

@onready var interaction_area: Area3D = $InteractionArea
@onready var InteractionLabel: Label3D = $InteractionLabel

var canInteract = false
var talking = false
const char_name = "Manfred"

@onready var quests: Array[Quest] = [
	QuestControl.get_node("LeafNectar"),
	QuestControl.get_node("TwigsGrass"),
	QuestControl.get_node("WeaponsandArmor"),
	QuestControl.get_node("Slay The Queen Bee")
]

const prologue: Array[String] = [
	"Your Majesty.",
	"RQUEEN ...",
	"...",
	"RQUEEN ?",
	"Oh, uhh-",
	"Termites- bad deal, tree is falling",
	"Our soldiers are starving",
	"We need to build an army.",
	"RQUEEN Well, how can I help, Manfred?",
	"Gather leaves and nectar, we are starving"
]

const prologue_questComplete: Array[String] = [
	"RQUEEN Here is the nectar and leaves",
	"Thank you your Majesty.",
	"...",
	"RQUEEN ...",
	"...",
	"...",
]

const level1: Array[String] = [
	"RQUEEN Do we need anything else?",
	"Oh yes your Majesty",
	"We need upgrades to the barracks",
	"Twigs and grass.",
	"RQUEEN How much?",
	"As much as you can carry. The more, the better.",
	"RQUEEN I’ll bring it."
]

const level1_questComplete: Array[String] = [
	"The barracks are ready.",
	"RQUEEN More soldiers mean a stronger army.",
	"A stronger army means victory.",
	"RQUEEN And victory is what we need.",
	"Many thanks, my Queen"
]

const level2: Array[String] = [
	"We need armor",
	"RQUEEN Yes we do, what kind?",
	"Bee stingers and ladybird wings",
	"RQUEEN I'll take care of it, Manfred"
]

const level2_questComplete: Array[String] = [
	"The army thanks you",
	"RQUEEN Thank you for the hearts!",
	"Anytime, your Majesty"
]

const queenbeeboss: Array[String] = [
	"The army stands ready, your Majesty",
	"RQUEEN Then let's strike!",
	"Yes, your majesty"
]

const queenbeeboss_questComplete: Array[String] = [
	"The battle is won",
	"The colony is safe for just a while",
	"RQUEEN We'll hit the termites next"
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
	if quests[GameManager.current_stage].quest_status == Quest.QuestStatus.available:
		$TalkToMe.visible = true

	
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("advance_dialog") and quests[GameManager.current_stage].quest_status != Quest.QuestStatus.finished:
		var key: String = GameManager.Stage[GameManager.current_stage]
		if canInteract:
			$AnimatedSprite3D.play("talking")
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
		$TalkToMe.visible = false
