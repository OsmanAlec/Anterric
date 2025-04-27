extends AnimatedSprite3D


const lines: Array[String] = [
	"Ouch that hurt!",
	"RQUEEN I bet it did >:(",
	"Little Queen Ant, listen now,",
	"The termites were making me do this",
	"They told us they'll fix the tree",
	"and that you are the one destroying it!",
	"RQUEEN But they're obviously eating the treee!",
	"They got into my head.",
	"Please Queen Ant, save us!",
	"Save us before the tree collapses!",
	"RQUEEN I will do my best, you may now rest."
]

var can_talk : bool = true

func _ready()-> void:
	self.play("idle")
	DialogManager.finished_talking.connect(_on_finished_talking)

	
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("advance_dialog") and can_talk:
		$"../Label3D".visible = false
		DialogManager.start_dialog(global_position, lines, "QueenBee")

func _on_finished_talking(cn):
	if cn != "QueenBee":
		return
	can_talk = false
	var quest = QuestControl.get_node("Slay The Queen Bee")
	quest.quest_status = quest.QuestStatus.finished
	$"../Control/AnimationPlayer".current_animation = "fade_out"
	await get_tree().create_timer(1.0).timeout
	get_tree().change_scene_to_file("res://scenes/enemies/termite_end.tscn")
