"""Collect 20 leaf and 10 nectar"""
extends Quest

func is_satisfied()-> bool:
	if PlayerData.inventory.find_slot_by_item_name("nectar") != null \
	and PlayerData.inventory.find_slot_by_item_name("leaf") != null:
		if PlayerData.inventory.find_slot_by_item_name("leaf").amount >= 20 \
		and PlayerData.inventory.find_slot_by_item_name("nectar").amount >= 10:
			PlayerData.inventory.find_slot_by_item_name("leaf").amount = 0
			PlayerData.inventory.find_slot_by_item_name("nectar").amount = 0
			return true
	return false

func upon_completion():
	PlayerData.max_health += 2
