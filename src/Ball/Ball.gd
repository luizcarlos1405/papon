extends KinematicBody2D

enum Direction {LEFT, RIGHT}

export var color: = Color(1, 1, 1)
export var radius: = 20.0
export var initial_speed: = 500
export var speed_increase_factor: = 1.2
export var angle_variation_degrees: = 15

var initial_direction: = 0.0
var direction: = Vector2.ZERO

var _speed: = initial_speed
var _collision_timer: = 0.2

onready var collision_shape: = $CollisionShape2D
onready var raycast: = $RayCast2D


func _init() -> void:
	add_to_group("Ball")


func _ready():
	collision_shape.shape.radius = radius

	randomize()
	initial_direction = randi() % 2

	reset(initial_direction)


func _physics_process(delta: float) -> void:
	var movement_ammount: = direction * _speed * delta

	raycast.cast_to = movement_ammount + movement_ammount.normalized() * radius
	raycast.force_raycast_update()

	# Testa o movimento com RayCast2D antes para evitar tunneling
	# TODO: Quando ocorre tunneling, a bola não é movida nesse frame e simplesmente
	# muda de direção. Talvez queiramos mudar isso por capricho ou se, no futuro,
	# isso gerar algum bug
	if raycast.get_collider():
		handle_collision(raycast.get_collision_normal())
		movement_ammount = Vector2.ZERO

	var collision: = move_and_collide(movement_ammount)

	if collision:
		handle_collision(collision.normal)


func _draw() -> void:
	draw_circle(Vector2.ZERO, radius, color)


func reset(to_direction: = -1) -> void:
	position = Vector2.ZERO
	_speed = initial_speed

	if to_direction == Direction.LEFT:
		direction = variate_direction(Vector2.LEFT, angle_variation_degrees)
	elif to_direction == Direction.RIGHT:
		direction = variate_direction(Vector2.RIGHT, angle_variation_degrees)


func handle_collision(normal: Vector2) -> void:
	direction = direction.bounce(normal)
	_speed *= speed_increase_factor


static func variate_direction(direction: Vector2, variation_degrees: float) -> Vector2:
	var output: = direction.rotated(rand_range(
		-deg2rad(variation_degrees),
		deg2rad(variation_degrees)
	))

	return output
