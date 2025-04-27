extends Quest

func is_satisfied()-> bool:
	if PlayerData.inventory.find_slot_by_item_name("ladybird_wings") != null:
		if PlayerData.inventory.find_slot_by_item_name("ladybird_wings").amount >= 2:
			return true
	return false

func upon_completion():
	PlayerData.max_health += 2
	PlayerData.inventory.find_slot_by_item_name("ladybird_wings").amount -= 2
	
