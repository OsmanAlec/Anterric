class_name QuestManager 
extends Node3D

#ui elements for quest info to show on screen
@onready var QuestContainer: GridContainer = GameManager.get_node("QuestBox/QuestContainer")

var active_quests: Array[Quest]
var completed_quests: Array[Quest]
	

func draw_quests():
	for child in QuestContainer.get_children():
		child.queue_free()
	
	for quest in active_quests:
		var quest_format = load("res://components/UI/QuestVisual.tscn").instantiate()
		quest_format.get_node("Title").text = quest.quest_name
		quest_format.get_node("Description").text = quest.quest_description
		QuestContainer.add_child(quest_format)
		print("redrawing quests")
		GameManager.get_node("QuestBox").visible = true
	
	for quest in completed_quests:
		var quest_format = load("res://components/UI/QuestVisual.tscn").instantiate()
		quest_format.get_node("Title").text = quest.quest_name
		quest_format.get_node("Description").text = quest.reached_goal_text
		QuestContainer.add_child(quest_format)
		
	
