extends Node
class_name KeybardControl

var game_width: float = ProjectSettings.get("display/window/size/width")
var game_height: float = ProjectSettings.get("display/window/size/height")
var game_x_center: = game_width / 2.0
var game_y_center: = game_height / 2.0

var move_up_action: = "lp_move_up"
var move_down_action: = "lp_move_down"

onready var pad = get_parent()

var _side: = 0


func _ready() -> void:
	if not pad.is_in_group("Pad"):
		push_error("TouchControl should be a child of a Pad")
		return

	if pad.global_position.x > game_x_center:
		move_up_action = "rp_move_up"
		move_down_action = "rp_move_down"

	else:
		move_up_action = "lp_move_up"
		move_down_action = "lp_move_down"


func _physics_process(delta: float) -> void:
	pad.input_direction = (Input.get_action_strength(move_down_action)
			- Input.get_action_strength(move_up_action))
