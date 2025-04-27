"""Collect 20 bee stingers"""
extends Quest

func is_satisfied()-> bool:

	if PlayerData.inventory.find_slot_by_item_name("bee_stinger") != null:
		if PlayerData.inventory.find_slot_by_item_name("bee_stinger").amount >= 20:
			return true
	return false

func upon_completion():
	PlayerData.damage += 1
	PlayerData.inventory.find_slot_by_item_name("bee_stinger").amount -= 20
	
