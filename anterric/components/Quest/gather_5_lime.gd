"""Collect 5 lime"""

extends Quest

func is_satisfied()-> bool:
	if PlayerData.inventory.find_slot_by_item_name("lime") != null:
		if PlayerData.inventory.find_slot_by_item_name("lime").amount >= 5:
			PlayerData.inventory.find_slot_by_item_name("lime").amount -= 5
			return true
	return false

func upon_completion():
	PlayerData.player.get_node("HitLeft").damage += 2
	PlayerData.player.get_node("HitRight").damage += 2
