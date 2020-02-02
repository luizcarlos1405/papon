extends "res://src/Pad/Pad.gd"

func _ready():
	match get_tree().get_meta("right_controller"):
		"HUMAN":
			add_child(KeybardControl.new())
		"AI":
			add_child(AIControl.new())
