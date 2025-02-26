class_name QuestManager 
extends Node3D

#ui elements for quest info to show on screen
@onready var QuestBox: CanvasLayer = GameManager.get_node('QuestBox')
@onready var QuestContainer: GridContainer = GameManager.get_node('QuestBox').get_node('GridContainer')


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
@export var reward_amount: int #currency reward
