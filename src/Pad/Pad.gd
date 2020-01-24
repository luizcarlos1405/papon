extends KinematicBody2D

export var acceleration: = 500
export var speed_angle_degrees: = 15
export var size: = Vector2(50, 200)
export var color: = Color(1, 1, 1)

var speed: = 500
var input_direction: = 0.0

var _velocity: = 0.0
var _target_velocity: = 0.0
var _min_y_position: = size.y / 2.0
onready var _max_y_position: float = ProjectSettings.get("display/window/size/height") - size.y / 2.0


func _init() -> void:
	add_to_group("Pad")


func _physics_process(delta: float) -> void:
	_velocity = calculate_velocity(input_direction, _velocity, speed, acceleration, delta)
	rotation_degrees = calculate_rotation(_velocity, speed, speed_angle_degrees)

	move_and_collide(Vector2(0.0, _velocity * delta))

	update()

# Este método é estático porque eu quero
static func calculate_velocity(
		input_direction: float,
		current_velocity: float,
		max_speed: float,
		current_acceleration: float,
		delta: float
	) -> float:
	var target_velocity: = max_speed * input_direction
	var ammount: = current_acceleration * delta
	var difference: = target_velocity - current_velocity

	if ammount >= abs(difference):
		return target_velocity

	var output: = current_velocity + ammount * sign(difference)

	return output


static func calculate_rotation(
		current_velocity: float,
		max_speed: float,
		max_angle: float
	) -> float:
	var ammount: = current_velocity / max_speed
	var output: = max_angle * ammount

	return output


func _draw() -> void:
	draw_rect(Rect2(-size / 2.0, size), color)