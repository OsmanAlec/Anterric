class_name SearchQuest extends QuestManager

#start quest
func start_quest() -> void:
	#make sure this quest is available to start
	if quest_status == QuestStatus.available:
		#update quest status
		quest_status = QuestStatus.started
		#update UI
		QuestBox.visible = true
		QuestTitle.text = quest_name
		QuestDescription.text = quest_description

#mark gpal as reached
func reached_goal() -> void:
	if quest_status == QuestStatus.started:
		#update quest status
		quest_status = QuestStatus.reached_goal
		#update ui
		QuestDescription.text = reached_goal_text

#finish the quest
func finish_quest() -> void:
	if quest_status == QuestStatus.reached_goal:
		#update quest status
		quest_status = QuestStatus.finished
		#update ui
		QuestBox.visible = false
		#reward player
		GameManager.Coins += reward_amount
		
