"""Collect 5 ladybird wings and 10 bee stingers"""

extends Quest

func is_satisfied()-> bool:
	if PlayerData.inventory.find_slot_by_item_name("ladybird_wings") != null \
	and PlayerData.inventory.find_slot_by_item_name("bee_stinger") != null:
		if PlayerData.inventory.find_slot_by_item_name("bee_stinger").amount >= 10 \
		and PlayerData.inventory.find_slot_by_item_name("ladybird_wings").amount >= 5:
			return true
	return false

func upon_completion():
	PlayerData.damage += 1
	PlayerData.inventory.find_slot_by_item_name("bee_stinger").amount = 0
	PlayerData.inventory.find_slot_by_item_name("ladybird_wings").amount = 0
