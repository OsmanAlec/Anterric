class_name Quest extends QuestManager

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
@export var reward_amount: int #might be redundant

var inventory = PlayerData.inventory

func _ready():
	if inventory:
		inventory.update.connect(_on_inventory_updated)

#start quest
func start_quest() -> void:
	#make sure this quest is available to start
	if quest_status == QuestStatus.available:
		#update quest status
		quest_status = QuestStatus.started
		QuestControl.active_quests.append(self)
		print("making a new quest with title", self.quest_name)
		QuestControl.draw_quests()

func _on_inventory_updated():
	check_status()  # Recheck quest status when inventory updates
		
#This function will get overridden by extended scripts
func is_satisfied()-> bool:
	return false
	
func check_status() -> void:
	if self.is_satisfied():
		reached_goal()
	return

#mark goal as reached
func reached_goal() -> void:
	if quest_status == QuestStatus.started:
		#update quest status
		quest_status = QuestStatus.reached_goal
		QuestControl.active_quests.remove_at(active_quests.find(self))
		QuestControl.completed_quests.append(self)
		QuestControl.draw_quests()
		

func upon_completion():
	return

#finish the quest
func finish_quest() -> void:
	if quest_status == QuestStatus.reached_goal:
		#update quest status
		quest_status = QuestStatus.finished
		QuestControl.completed_quests.remove_at(completed_quests.find(self))
		QuestControl.draw_quests()
		#reward player
		upon_completion()
		
