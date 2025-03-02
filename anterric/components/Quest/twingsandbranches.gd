"""Collect 20 twigs and 10 grass"""

extends Quest

func is_satisfied()-> bool:
	if PlayerData.inventory.find_slot_by_item_name("twig") != null \
	and PlayerData.inventory.find_slot_by_item_name("grass_tuft") != null:
		if PlayerData.inventory.find_slot_by_item_name("twig").amount >= 20 \
		and PlayerData.inventory.find_slot_by_item_name("grass_tuft").amount >= 10:
			PlayerData.inventory.find_slot_by_item_name("twig").amount -= 20
			PlayerData.inventory.find_slot_by_item_name("grass_tuft").amount -= 10
			return true
	return false

func upon_completion():
	PlayerData.max_health += 2
