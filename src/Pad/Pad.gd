extends KinematicBody2D

enum Side {LEFT, RIGHT}

export(Side) var side: int = 0 setget set_side
export var acceleration: = 800
export var angular_acceleration: = 4 * PI
export var max_angle: = PI / 10
export var size: = Vector2(50, 200)
export var color: = Color(1, 1, 1)

var max_angular_speed: = PI
var speed: = 500
var input_direction: = Vector2.ZERO

var _velocity: = 0.0
var _target_velocity: = 0.0
var _min_y_position: = size.y / 2.0
var _angular_velocity: = 0.0
var _target_rotation: = 0.0
var position_x

onready var _max_y_position: float = ProjectSettings.get("display/window/size/height") - size.y / 2.0


func _init() -> void:
	add_to_group("Pad")


func _ready() -> void:
	position_x = position.x


func _physics_process(delta: float) -> void:
	_velocity = calculate_velocity(input_direction.y, _velocity, speed, acceleration, delta)
	_target_rotation = calculate_rotation(input_direction, max_angle)
	_angular_velocity = calculate_angular_velocity(
		_angular_velocity,
		_target_rotation,
		rotation,
		max_angular_speed,
		angular_acceleration,
		delta
	)

	var final_rotation = move_toward(rotation, _target_rotation, abs(_angular_velocity) * delta)

	if final_rotation == PI:
		final_rotation = 3.1414
	# Temos que user stepify por causa de um bug ultra obscuro:
	# https://github.com/godotengine/godot/issues/47154
	rotation = final_rotation if final_rotation != 3.141593 else 3.1415
	move_and_collide(Vector2(0.0, _velocity * delta))

	# Não deixa que nada o mova no eixo x
	position.x = position_x

# Este método é estático porque eu quero
# warning-ignore:shadowed_variable
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

static func calculate_angular_velocity(
		angular_velocity: float,
		target_rotation: float,
		rotation: float,
		max_angular_speed: float,
		angular_acceleration: float,
		delta: float
	) -> float:
	var rotation_direction: = sign(target_rotation - rotation)
	var target_angular_velocity: = rotation_direction * max_angular_speed
	var angle_speed_delta: = angular_acceleration * delta

	var result = move_toward(
		angular_velocity,
		target_angular_velocity,
		angle_speed_delta
	)

	return result


static func calculate_rotation(
		input_direction: Vector2,
		max_angle: float
	) -> float:
	var minimum: = -max_angle
	var maximum: = max_angle

	return clamp(
		range_lerp(
			input_direction.x,
			-1.0,
			1.0,
			minimum,
			maximum
		),
		minimum,
		maximum
	)


func set_side(value: int) -> void:
	side = value

	yield(self, "ready")

	if side == Side.RIGHT:
		$Sprite.flip_h = true
		$CollisionShape2D.rotation = PI

