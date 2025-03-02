"""Collect 10 tufts of Grass"""

extends Quest

func is_satisfied()-> bool:
	if PlayerData.inventory.find_slot_by_item_name("grass_tuft") != null:
		if PlayerData.inventory.find_slot_by_item_name("grass_tuft").amount >= 5:
			return true
	return false

func upon_completion():
	PlayerData.coins = 5
