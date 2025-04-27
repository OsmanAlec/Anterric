"""Collect 5 lime"""

extends Quest

func is_satisfied()-> bool:
	if PlayerData.inventory.find_slot_by_item_name("lime") != null:
		if PlayerData.inventory.find_slot_by_item_name("lime").amount >= 5:
			return true
	return false

func upon_completion():
	PlayerData.inventory.find_slot_by_item_name("lime").amount -= 5
	PlayerData.damage += 1
