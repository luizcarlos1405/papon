extends Node2D

var _points_template: = "%s x %s"
var _left_points: = 0
var _right_points: = 0
var _ball_next_direction: = randi() % 2

onready var points: Label = $GUI/Control/Points
onready var time_left: Label = $GUI/Control/TimeLeft
onready var countdown: Label = $GUI/Control/Countdown
onready var start_message: Label = $GUI/Control/StartMessage
onready var ball: = $Ball
onready var left_point_area: = $LeftPointArea
onready var right_point_area: = $RightPointArea
onready var match_timer: Timer = $MatchTimer


func _ready():
	ball.hide()

	update_scoreboard()

	left_point_area.connect("body_entered", self, "_on_LeftPointArea_body_entered")
	right_point_area.connect("body_entered", self, "_on_RightPointArea_body_entered")

	match_timer.connect("timeout", self, "_on_MatchTimer_timeout")
	countdown.connect("finished", self, "_on_Countdown_finished")


func _on_MatchTimer_timeout() -> void:
	# TODO: colocar animação de vitória
	get_tree().reload_current_scene()


func _on_Countdown_finished() -> void:
	ball.show()
	ball.start(_ball_next_direction)


func _on_LeftPointArea_body_entered(body: PhysicsBody2D) -> void:
	if body.is_in_group("Ball"):
		_right_points += 1
		update_scoreboard()

		_ball_next_direction = ball.Direction.RIGHT
		ball.reset()

		countdown.start()


func _on_RightPointArea_body_entered(body: PhysicsBody2D) -> void:
	if body.is_in_group("Ball"):
		_left_points += 1
		update_scoreboard()

		_ball_next_direction = ball.Direction.LEFT
		ball.reset()

		countdown.start()


func _process(delta: float) -> void:
	time_left.text = "%.2f" % match_timer.time_left


func _input(event: InputEvent) -> void:
	if event is InputEventKey:
		if event.pressed:
			if start_message.visible:
				start_match()



func start_match() -> void:
	match_timer.start()
	countdown.start()
	start_message.hide()


func update_scoreboard() -> void:
	points.text = _points_template % [_left_points, _right_points]
