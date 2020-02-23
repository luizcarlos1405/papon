extends Control

export var ScnModeSelection: PackedScene


onready var play: Button = $Buttons/Play
onready var options: Button = $Buttons/Options
onready var quit: Button = $Buttons/Quit


func _ready():
	play.connect("pressed", self, "_on_Play_pressed")
	options.connect("pressed", self, "_on_Options_pressed")
	quit.connect("pressed", self, "_on_Quit_pressed")
	pass


func _on_Play_pressed() -> void:
	get_tree().change_scene_to(ScnModeSelection)
	pass


func _on_Options_pressed() -> void:
	pass


func _on_Quit_pressed() -> void:
	OS.quit()
	pass
