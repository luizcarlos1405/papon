extends Camera2D
class_name ShakyCamera

export(float, 0.1, 99999) var max_shake_duration: = 2.0
export var max_translation: = Vector2(100, 100)
export var max_rotation: = 10

var trauma: = 0.0 setget set_trauma

var _translation_seed: = Vector2(randi(), randi())
var _rotation_seed: = randi()
var _open_simplex: = OpenSimplexNoise.new()
var _time: = 0.0
var _angle_degree_offset: = 0.0


func _ready() -> void:
	_open_simplex.period = 0.15


func _process(delta: float) -> void:
	_time += delta

	self.trauma -= delta * 1.0 / max_shake_duration

	var shake: = trauma * trauma
	# Translation
	_open_simplex.seed = _translation_seed.x as int
	offset.x = max_translation.x * shake * _open_simplex.get_noise_1d(_time)
	_open_simplex.seed = _translation_seed.y as int
	offset.y = max_translation.y * shake * _open_simplex.get_noise_1d(_time)
	_open_simplex.seed = _rotation_seed as int
	# Rotation
	rotation_degrees -= _angle_degree_offset
	_angle_degree_offset = max_rotation * shake * _open_simplex.get_noise_1d(_time)
	rotation_degrees += _angle_degree_offset


func set_trauma(value: float) -> void:
	trauma = clamp(value, 0, 1)
