extends Quest

var ladybird_wings = 0

func is_satisfied()-> bool:
	return false

func upon_completion():
	PlayerData.max_health += 2
	
