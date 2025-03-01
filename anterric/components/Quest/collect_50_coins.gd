"""Collect 50 coins"""

extends Quest

func is_satisfied()-> bool:
	return PlayerData.coins >= 50  

func upon_completion():
	PlayerData.coins = 0
