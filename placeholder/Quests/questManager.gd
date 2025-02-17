extends Node

var activeQuests: Array[Quest] = []

# Add a quest to the system
func addQuest(quest: Quest):
	if quest not in activeQuests:
		activeQuests.append(quest)
		print("Quest added: ", quest.title)

# Check and update quest objectives
func updateQuestProgress(quest: Quest, objective: String):
	if quest in activeQuests and not quest.is_completed:
		if objective in quest.objectives:
			quest.objectives.erase(objective)
			print("Objective Complete: ", quest.title)

# Get all active quests
func getActiveQuests() -> Array[Quest]:
	return activeQuests

# Get completed quests
func getCompletedQuests() -> Array[Quest]:
	return activeQuests.filter(func(q): return q.isCompleted)
