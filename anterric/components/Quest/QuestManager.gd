class_name QuestManager 
extends Node3D

#ui elements for quest info to show on screen
@onready var QuestContainer: VBoxContainer = PlayerManager.get_node("HUD/QuestBox/VBoxContainer/Control/QuestContainer")
@onready var QuestBox: Control = PlayerManager.get_node("HUD/QuestBox")

var active_quests: Array[Quest]
var completed_quests: Array[Quest]    
	
func check_quests():
	for quest in active_quests:
		quest.check_status()

func reset_quests():
	for quest in completed_quests:
		quest.quest_status = Quest.QuestStatus.started
		active_quests.append(quest)

	
	completed_quests.clear()
	draw_quests()

func draw_quests():
	for child in QuestContainer.get_children():
		child.queue_free()
	
	for quest in active_quests:
		var quest_format = load("res://components/UI/QuestVisual.tscn").instantiate()
		quest_format.get_node("Title").text = quest.quest_name
		quest_format.get_node("Description").text = quest.quest_description
		QuestContainer.add_child(quest_format)
		QuestBox.visible = true
	
	for quest in completed_quests:
		var quest_format = load("res://components/UI/QuestVisual.tscn").instantiate()
		quest_format.get_node("Title").text = quest.quest_name
		quest_format.get_node("Description").text = quest.reached_goal_text
		QuestContainer.add_child(quest_format)
		
		
