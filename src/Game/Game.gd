extends Node2D

onready var ball: = $Ball
onready var left_point_area: = $LeftPointArea
onready var right_point_area: = $RightPointArea

var _points_template: = "%s x %s"
var _left_points: = 0
var _right_points: = 0

onready var label: Label = $GUI/Control/Label


func _ready():
	left_point_area.connect("body_entered", self, "_on_LeftPointArea_body_entered")
	right_point_area.connect("body_entered", self, "_on_RightPointArea_body_entered")

	update_scoreboard()


func _on_LeftPointArea_body_entered(body: PhysicsBody2D) -> void:
	if body.is_in_group("Ball"):
		_right_points += 1
		ball.reset(ball.Direction.RIGHT)
		label.text = _points_template % [_left_points, _right_points]
		update_scoreboard()


func _on_RightPointArea_body_entered(body: PhysicsBody2D) -> void:
	if body.is_in_group("Ball"):
		_left_points += 1
		ball.reset(ball.Direction.LEFT)
		update_scoreboard()

func update_scoreboard() -> void:
	label.text = _points_template % [_left_points, _right_points]
