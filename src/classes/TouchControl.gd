extends Node
class_name TouchControl

var game_width: float = ProjectSettings.get("display/window/size/width")
var game_height: float = ProjectSettings.get("display/window/size/height")
var game_x_center: = game_width / 2.0
var game_y_center: = game_height / 2.0

var _side: = 0

onready var pad = get_parent()


func _ready():
	if not pad.is_in_group("Pad"):
		push_error("TouchControl should be a child of a Pad")
		return

	if pad.global_position.x > game_x_center:
		_side = 1
	else:
		_side = -1


func _input(event: InputEvent) -> void:
	if event is InputEventScreenTouch:
		if not is_on_right_side(event.position):
			return

		if event.pressed:
			if event.position.y > game_y_center:
				pad.input_direction = 1
			else:
				pad.input_direction = -1

		else:
			pad.input_direction = 0.0


func is_on_right_side(touch_position) -> bool:
	if _side > 0:
		return touch_position.x > game_x_center

	return touch_position.x < game_x_center
