"""Collect 10 tufts of Grass"""

extends Quest

func is_satisfied()-> bool:
	if PlayerData.inventory.find_slot_by_item_name("nectar") != null \
	and PlayerData.inventory.find_slot_by_item_name("leaf") != null:
		if PlayerData.inventory.find_slot_by_item_name("leaf").amount >= 10 \
		and PlayerData.inventory.find_slot_by_item_name("nectar").amount >= 5:
			return true
	return false

func upon_completion():
	PlayerData.max_health += 2
