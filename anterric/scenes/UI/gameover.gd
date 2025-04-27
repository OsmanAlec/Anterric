extends Control

func _ready() -> void:
	PlayerData.current_health = PlayerData.max_health
	PlayerData.coins = 0
	PlayerData.inventory.reset_inv()
	QuestControl.reset_quests()
	PlayerData.HUD.visible = false
	PlayerManager.get_node("HUD/InventoryUi").update_slots()
	await get_tree().create_timer(1.0).timeout
	$CenterContainer/VBoxContainer/VBoxContainer/retry.grab_focus()

func _on_retry_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/home/ant_hill.tscn")

func _on_quit_pressed() -> void:
	get_tree().quit()
