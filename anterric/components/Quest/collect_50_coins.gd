"""Collect 50 coins"""

extends Quest

func is_satisfied()-> bool:
	print(PlayerData.coins)
	return PlayerData.coins >= 50  

func upon_completion():
	PlayerData.coins = 0
