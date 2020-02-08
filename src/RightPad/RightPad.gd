tool
extends "res://src/Pad/Pad.gd"

func _ready():
	match get_tree().get_meta("right_controller"):
		"HUMAN":
			var keyboard_control: = KeybardControl.new()
			keyboard_control.move_up_action = "rp_move_up"
			keyboard_control.move_down_action = "rp_move_down"
			add_child(keyboard_control)
		"AI":
			add_child(AIControl.new())
