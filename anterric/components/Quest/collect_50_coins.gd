"""Collect 20 coins"""

extends Quest

func is_satisfied()-> bool:
	return PlayerData.coins >= 20 

func upon_completion():
	PlayerData.coins = 0
