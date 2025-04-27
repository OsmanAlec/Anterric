extends Control

func _ready() -> void:
	PlayerManager.get_node("Shaders").visible = false
	PlayerManager.get_node("player_menu").visible = false
	PlayerData.HUD.visible = false
	get_node("VBoxContainer/Button").grab_focus()
	# TODO : fix button not working with mouse
	


func _on_button_pressed() -> void:
	get_tree().quit()
