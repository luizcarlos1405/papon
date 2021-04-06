extends KinematicBody2D

enum Direction {LEFT, RIGHT}

export var color: = Color(1, 1, 1)
export var radius: = 20.0
export var initial_speed: = 500.0
export var speed_increase_factor: = 50.0
export var angle_variation_degrees: = 15.0
export var max_angle: = deg2rad(70)

var direction: = Vector2.ZERO

var _speed: = initial_speed
var _collision_timer: = 0.2
var _last_direction: int

onready var collision_shape: = $CollisionShape2D
onready var raycast: = $RayCast2D
onready var audio_stream_player = $AudioStreamPlayer
onready var max_angle_sine: = abs(sin(max_angle))


func _init() -> void:
	add_to_group("Ball")


func _ready():
	randomize()

	$Particles2D.set_as_toplevel(true)
	hide()
	collision_shape.shape.radius = radius
	_last_direction = randi() % 2

	reset()
	Event.connect("Game_state_changed", self, "_on_Event_Game_state_changed")
	Event.connect("scored", self, "_on_Event_scored")
	Event.connect("Countdown_finished", self, "_on_Event_Countdown_finished")


func _on_Event_Game_state_changed(state: int) -> void:
	match state:
		Enum.GameState.IN_GAME:
			show()
		Enum.GameState.POS_GAME:
			hide()
			reset()


func _on_Event_scored(side: String) -> void:
	$Particles2D.global_position = global_position

	if side == "LEFT":
		$Particles2D.rotation = 0
	else:
		$Particles2D.rotation = PI

	$Particles2D.emitting = true

	reset()


func _on_Event_Countdown_finished() -> void:
	if _last_direction == Direction.LEFT:
		start(Direction.RIGHT)
	elif _last_direction == Direction.RIGHT:
		start(Direction.LEFT)


func _physics_process(delta: float) -> void:
	var movement_ammount: = direction * _speed * delta

	if movement_ammount.length() > 2 * radius:
		raycast.position = direction * radius
		raycast.cast_to = movement_ammount
		raycast.force_raycast_update()

	# Testa o movimento com RayCast2D antes para evitar tunneling
	# Talvez tratar totalmente a coisão e não deixar nada pro move_and_collide
	# no caso de tunneling
	if raycast.get_collider():
		movement_ammount = to_local(raycast.get_collision_point())

	var collision: = move_and_collide(movement_ammount)

	if collision and abs(collision.normal.angle_to(direction)) > PI / 2.0:
		handle_collision(collision)


func reset() -> void:
	position = Vector2.ZERO
	_speed = 0.0


func start(to_direction) -> void:
	_last_direction = to_direction
	_speed = initial_speed

	if to_direction == Direction.LEFT:
		direction = variate_direction(Vector2.LEFT, angle_variation_degrees)
	elif to_direction == Direction.RIGHT:
		direction = variate_direction(Vector2.RIGHT, angle_variation_degrees)


func handle_collision(collision: KinematicCollision2D) -> void:
	var bounce_direction = direction.bounce(collision.normal)

	# Garante que a direnção vai estar apontando para a direção oposta após colidir
	if (sign(bounce_direction.x) == sign(direction.x) and collision.collider.is_in_group('Pad')):
		bounce_direction.x *= -1

	direction = bounce_direction

	if (abs(sin(direction.angle())) > max_angle_sine):
		# Obtem os sinais do vetor ou randomiza um sinal se o valor for 0
		var dir_signs = Vector2(
			sign(direction.x) if direction.x else sign(randi() % 2 - 0.5),
			sign(direction.y) if direction.y else sign(randi() % 2 - 0.5)
		)

		direction = dir_signs * Vector2.RIGHT.rotated(max_angle)

	if collision.collider.is_in_group("Pad"):
		_speed += speed_increase_factor
		Event.emit_signal("Ball_hit_pad")

	audio_stream_player.play()


# warning-ignore:shadowed_variable
static func variate_direction(direction: Vector2, variation_degrees: float) -> Vector2:
	var output: = direction.rotated(rand_range(
		-deg2rad(variation_degrees),
		deg2rad(variation_degrees)
	))

	return output
