extends Quest

func is_satisfied()-> bool:
	print(PlayerData.inventory)

	#There is no error handling in this language?????
	#Simple if statement since thers no error handling !?
	if PlayerData.inventory.find_slot_by_item_name("ladybird_wings") != null:
		if PlayerData.inventory.find_slot_by_item_name("ladybird_wings").amount >= 5:
			PlayerData.inventory.find_slot_by_item_name("ladybird_wings").amount -= 5
			return true
	return false

func upon_completion():
	PlayerData.max_health += 2
	
