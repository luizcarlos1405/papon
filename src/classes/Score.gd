extends Label
class_name Score

var _score_template: = "%s x %s"
var _left_score: = 0
var _right_score: = 0

onready var animation_player: AnimationPlayer = $AnimationPlayer


func _ready() -> void:
	hide()

	Event.connect("Game_match_started", self, "_on_Event_Game_match_started")
	Event.connect("scored", self, "_on_Event_scored")
	Event.connect("Game_match_ended", self, "_on_Event_Game_match_ended")


func _on_Event_Game_match_started() -> void:
	show()


func _on_Event_Game_match_ended() -> void:
	show_result()

	yield(Event, "Game_match_started")
	reset()


func _on_Event_scored(side: String) -> void:
	if side == "LEFT":
		_right_score += 1
		update_scoreboard()

	elif side == "RIGHT":
		_left_score += 1
		update_scoreboard()

#		_ball_next_direction = ball.Direction.LEFT
#		ball.reset()


func update_scoreboard() -> void:
	text = _score_template % [_left_score, _right_score]


func show_result() -> void:
	animation_player.play("show_result")


func reset() -> void:
	animation_player.play_backwards("show_result")