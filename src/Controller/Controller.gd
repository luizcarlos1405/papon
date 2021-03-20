extends Control

const Pad: = preload("res://src/Pad/Pad.gd")

export var pad_path: = NodePath()
export var normal_color: = Color(1, 1, 1)
export var active_color: = Color(1, 1, 1)

var pad: Pad

var _input_center: = Vector2.ZERO
var _touch_by_index: = {}

onready var up_arrow: = $Arrows/Up
onready var down_arrow: = $Arrows/Down
onready var arrows: = $Arrows


func _ready():
	pad = get_node_or_null(pad_path)

	arrows.connect("resized", self, "_on_Arrows_resized")
	down_arrow.self_modulate = normal_color
	up_arrow.self_modulate = normal_color


func _process(delta: float) -> void:
	var input_direction: = calculate_input_direction()
	send_input_direction(input_direction)

	pass


# Não podemos usar _gui_input pro causa desse bug: https://github.com/godotengine/godot/issues/29525
func _input(event: InputEvent) -> void:
	if owner and owner.state == Enum.GameState.PRE_GAME:
		return

	if not (event is InputEventScreenTouch or event is InputEventScreenDrag):
		return

	if not get_global_rect().has_point(event.position) and not _touch_by_index.has(event.index):
		return

	if event is InputEventScreenTouch:
		var event_position: Vector2 = event.position - rect_global_position

		if event.pressed:
			_touch_by_index[event.index] = event_position

		else:
			_touch_by_index.erase(event.index)

	elif event is InputEventScreenDrag:
		var event_position: Vector2 = event.position - rect_global_position

		if _touch_by_index.has(event.index):
			_touch_by_index[event.index] = event_position


func calculate_input_direction() -> Vector2:
	if _touch_by_index.empty():
		return Vector2(pad.input_direction.x, 0)

	var max_x_position: float = arrows.rect_size.x / 2
	var reference_point: Vector2
	var event_position: Vector2
	var is_two_touches: = _touch_by_index.size() > 1

	if not is_two_touches:
		reference_point = _input_center
		event_position = _touch_by_index.values()[0]

	else:
		reference_point = _touch_by_index.values()[0]
		event_position = _touch_by_index.values()[1]

	var position_from_reference: = reference_point - event_position
	var vertical_direction: float = sign(-position_from_reference.y)
	var rotation_intensity: = clamp(
		position_from_reference.x / max_x_position,
		-1,
		1
	)

	# De -1 até 1
	var rotation_input = rotation_intensity * vertical_direction

	# Faz ele parar se forem dois toques
	if is_two_touches:
		vertical_direction = 0

	return Vector2(rotation_input, vertical_direction)


func send_input_direction(input_direction: Vector2) -> void:
	if not pad:
		print_debug("No pad selected")
		return

	pad.input_direction = input_direction

	arrows.set_rotation(pad.input_direction.x * pad.max_angle)

	if (input_direction.y > 0):
		down_arrow.self_modulate = active_color
		up_arrow.self_modulate = normal_color
	elif (input_direction.y < 0):
		up_arrow.self_modulate = active_color
		down_arrow.self_modulate = normal_color
	else:
		down_arrow.self_modulate = normal_color
		up_arrow.self_modulate = normal_color


func _on_Arrows_resized() -> void:
	arrows.rect_pivot_offset = arrows.rect_size / 2
	_input_center = arrows.rect_pivot_offset + arrows.rect_position
