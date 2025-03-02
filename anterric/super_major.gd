extends CharacterBody3D

@onready var interaction_area: Area3D = $InteractionArea
@onready var InteractionLabel: Label3D = $Label3D

var canInteract = false
var talking = false
const char_name = "Manfred"

@onready var quests: Array[Quest] = [
	QuestControl.get_node("LeafNectar"),
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
	"heyy hey heyyy",
	"RQUEEN here I got you the coins!",
	"thanks... I'll take ALL of them",
	"RQUEEN What!?"
]

const level1: Array[String] = [
	"heyYyYy",
	"RQUEEN Now what do you want?",
	"you need lady bird wings",
	"RQUEEN Do YOU need them?",
	"no, you do... trust me."
]

const level1_questComplete: Array[String] = [
	"good job",
	"...",
	"RQUEEN you scammed me again!",
	"no, I did not",
	"it's dangerous to go alone",
	"take this"
]

const level2: Array[String] = [
	"RQUEEN So what's your name?",
	"bee stingers",
	"RQUEEN Bee stingers? that's strange",
	"bring me bee stingers",
	"RQUEEN I'll call you Garvan",
	"ok . . ."
]

const level2_questComplete: Array[String] = [
	"i'll upgrade your sword",
	"RQUEEN Wow thanks, Garvan!",
	"Garvan",
	"gaaarrrvaaannnnn"
]

const queenbeeboss: Array[String] = [
	"it's time",
	"RQUEEN For what, Garvan?",
	"it's time, you're ready",
	"to get rid of the bee queen",
	"RQUEEN Yes buddy, I am ready!!!"
]

const queenbeeboss_questComplete: Array[String] = [
	"good job!!!",
	"RQUEEN Thank you, Garvan!",
	"garvan needs to work with chemicals",
	"you're not ready for the termites...",
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

	
func _unhandled_key_input(event):
	if event.is_action_pressed("advance_dialog"):
		var key: String = PlayerData.Stage[PlayerData.current_stage]
		if canInteract:
			$AnimatedSprite3D.play("talking")
			InteractionLabel.hide()
			if quests[PlayerData.current_stage].quest_status == Quest.QuestStatus.reached_goal:
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
	var key: String = PlayerData.Stage[PlayerData.current_stage]
	
	if quests[PlayerData.current_stage].quest_status == Quest.QuestStatus.reached_goal:
		quests[PlayerData.current_stage].finish_quest()
		PlayerData.current_stage += 1
	elif quests[PlayerData.current_stage].quest_status == Quest.QuestStatus.available:
		quests[PlayerData.current_stage].start_quest()
