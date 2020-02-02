extends Node
class_name AIControl

onready var _ball: KinematicBody2D = get_tree().get_nodes_in_group("Ball")[0]
onready var pad: KinematicBody2D = get_parent()


func _physics_process(delta: float) -> void:
	pad.input_direction = clamp(_ball.global_position.y - pad.global_position.y, -1, 1)
	pass
