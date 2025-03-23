"""Collect 5 tufts of Grass"""

extends Quest

func is_satisfied()-> bool:
	if PlayerData.inventory.find_slot_by_item_name("grass_tuft") != null:
		if PlayerData.inventory.find_slot_by_item_name("grass_tuft").amount >= 5:
			return true
	return false

func upon_completion():
	PlayerData.player.get_node("Health").max_health += 2
	PlayerData.inventory.find_slot_by_item_name("grass_tuft").amount -= 5
