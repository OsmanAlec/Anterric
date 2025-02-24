extends CharacterBody3D

@export var quest: SearchQuest

var canQuest = false

func _on_interaction_area_body_entered(body: PhysicsBody3D) -> void:
	#check for player
	print("wtf")
	print(body)
	if body.is_in_group("Player"):
		canQuest = true
		print("player entered quest area")
		#if quest is available
		if quest.quest_status == quest.QuestStatus.available:
			#start the quest
			print("quest started")
			quest.start_quest()
		
		#if player has reached goal
		if quest.quest_status == quest.QuestStatus.reached_goal:
			#finish the quest
			print("quest completed")
			quest.finish_quest()
			


func _on_interaction_area_body_exited(body: Node3D) -> void:
	if body.is_in_group("Player"):
		canQuest = false
