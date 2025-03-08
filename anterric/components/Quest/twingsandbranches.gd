"""Collect 5 twigs and 10 grass"""

extends Quest

func is_satisfied()-> bool:
	if PlayerData.inventory.find_slot_by_item_name("twig") != null \
	and PlayerData.inventory.find_slot_by_item_name("grass_tuft") != null:
		if PlayerData.inventory.find_slot_by_item_name("twig").amount >= 5 \
		and PlayerData.inventory.find_slot_by_item_name("grass_tuft").amount >= 10:
			return true
	return false

func upon_completion():
	PlayerData.max_health += 2
	PlayerData.inventory.find_slot_by_item_name("twig").amount = 0
	PlayerData.inventory.find_slot_by_item_name("grass_tuft").amount = 0
