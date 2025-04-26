extends Control

@onready var OptionsMenu = get_node("OptionsMenu")
@onready var Main = get_node("Main")
@onready var default_button = get_node("%Resume")
var is_open = false

func _ready():
	close()

func _physics_process(delta):
	if PlayerData.player:
		if Input.is_action_just_pressed("settings") and !is_open:
			open()
				
func open():
	visible = true
	is_open = true
	get_tree().paused = true
	PlayerManager.get_node("Shaders").visible = false
	PlayerData.HUD.visible = false
	default_button.grab_focus()

func close():
	visible = false
	is_open = false
	get_tree().paused = false
	PlayerManager.get_node("Shaders").visible = true
	PlayerData.HUD.visible = true


func _on_resume_pressed() -> void:
	close()

func _on_quit_pressed() -> void:
	get_tree().quit()


func _on_options_pressed() -> void:
	Main.visible = false
	OptionsMenu.visible = true
	OptionsMenu.default_button.grab_focus()
	

func _on_options_menu_back_pressed() -> void:
	Main.visible = true
	OptionsMenu.visible = false
	default_button.grab_focus()
