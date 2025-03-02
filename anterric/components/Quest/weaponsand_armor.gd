"""Collect 20 ladybird wings and 10 bee stingers"""

extends Quest

func is_satisfied()-> bool:
	if PlayerData.inventory.find_slot_by_item_name("ladybird_wings") != null \
	and PlayerData.inventory.find_slot_by_item_name("bee_stinger") != null:
		if PlayerData.inventory.find_slot_by_item_name("bee_stinger").amount >= 10 \
		and PlayerData.inventory.find_slot_by_item_name("ladybird_wings").amount >= 20:
			PlayerData.inventory.find_slot_by_item_name("bee_stinger").amount = 0
			PlayerData.inventory.find_slot_by_item_name("ladybird_wings").amount = 0
			return true
	return false

func upon_completion():
	PlayerData.player.get_node("HitLeft").damage += 2
	PlayerData.player.get_node("HitRight").damage += 2
