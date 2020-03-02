extends Control

export var GamePackedScene: PackedScene

var HumanControl = TouchControl if OS.get_name() == "Android" else KeybardControl

onready var human_vs_ai: Button = $Modes/HumanVSHuman
onready var human_vs_human: Button = $Modes/HumanVSAI
onready var ai_vs_ai: Button = $Modes/AIVSAI


func _ready():
	human_vs_ai.connect("pressed", self, "_on_HumanVSHuman_pressed")
	human_vs_human.connect("pressed", self, "_on_HumanVSAI_pressed")
	ai_vs_ai.connect("pressed", self, "_on_AIVSAI_pressed")


func _on_HumanVSHuman_pressed() -> void:
	get_tree().set_meta("left_controller", HumanControl)
	get_tree().set_meta("right_controller", HumanControl)

	get_tree().change_scene_to(GamePackedScene)


func _on_HumanVSAI_pressed() -> void:
	get_tree().set_meta("left_controller", HumanControl)
	get_tree().set_meta("right_controller", AIControl)

	get_tree().change_scene_to(GamePackedScene)


func _on_AIVSAI_pressed() -> void:
	get_tree().set_meta("left_controller", AIControl)
	get_tree().set_meta("right_controller", AIControl)

	get_tree().change_scene_to(GamePackedScene)
