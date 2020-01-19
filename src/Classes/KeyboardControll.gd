extends Node
class_name KeybardControll

export var move_up_action: = "lp_move_up"
export var move_down_action: = "lp_move_down"

onready var pad = get_parent()


func _ready() -> void:
	if not pad.is_in_group("Pad"):
		push_error("KeyboardControlle should be a child of a Pad")


func _physics_process(delta: float) -> void:
	pad.input_direction = (Input.get_action_strength(move_down_action)
			- Input.get_action_strength(move_up_action))