tool
extends "res://src/Pad/Pad.gd"

func _ready():
	if not get_tree().has_meta("right_controller"):
		return

	match get_tree().get_meta("left_controller"):
		"HUMAN":
			var keyboard_control: = KeybardControl.new()
			keyboard_control.move_up_action = "lp_move_up"
			keyboard_control.move_down_action = "lp_move_down"
			add_child(keyboard_control)

		"AI":
			add_child(AIControl.new())
