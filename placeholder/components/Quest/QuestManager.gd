class_name QuestManager extends Node2D

#ui elements for quest info to show on screen
@onready var QuestBox: CanvasLayer = GameManager.get_node('QuestBox')
@onready var QuestTitle: RichTextLabel = GameManager.get_node('QuestBox').get_node('QuestTitle')
@onready var QuestDescription: RichTextLabel = GameManager.get_node('QuestBox').get_node('QuestDescription')

@export_group("Quest Settings")
@export var quest_name: String #name of quest
@export var quest_description: String #ui description text
@export var reached_goal_text: String #ui description after beating quest

#all quest statuses
enum QuestStatus{
	available,
	started,
	reached_goal,
	finished,
}

#quest status
@export var quest_status: QuestStatus = QuestStatus.available

#reward settings
@export_group("Reward Settings")
@export var reward_amount: int #curreny reward
@export var xp_amount: int 
