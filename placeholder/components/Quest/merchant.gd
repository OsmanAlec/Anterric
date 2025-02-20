extends Area3D

@export var quest: SearchQuest

func _on_body_entered(body: Node3D) -> void:
	#check for player
	if body.is_in_group("Player"):
		#if quest is available
		if quest.quest_status == quest.QuestStatus.available:
			#start the quest
			quest.start_quest()
		
		#if player has reached goal
		if quest.quest_status == quest.QuestStatus.reached_goal:
			#finish the quest
			quest.finish_quest()
