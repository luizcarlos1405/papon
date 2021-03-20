extends Label
class_name Score

export var score_to_win: = 5

var _score_template: = "%s x %s"
var _left_score: = 0
var _right_score: = 0

onready var animation_player: AnimationPlayer = $AnimationPlayer


func _ready() -> void:
	hide()

	Event.connect("Game_state_changed", self, "_on_Event_Game_state_changed")
	Event.connect("scored", self, "_on_Event_scored")


func _on_Event_Game_state_changed(state: int) -> void:
	if state == Enum.GameState.IN_GAME:
		_left_score = 0
		_right_score = 0
		update_scoreboard()


func _on_Event_scored(side: String) -> void:
	if side == "LEFT":
		_right_score += 1
		update_scoreboard()

	elif side == "RIGHT":
		_left_score += 1
		update_scoreboard()


	if _left_score >= score_to_win or _right_score >= score_to_win:
		Event.emit_signal("won_by_score")


func update_scoreboard() -> void:
	text = _score_template % [_left_score, _right_score]


func show_result() -> void:
	animation_player.play("show_result")


func reset() -> void:
	animation_player.play("hide_result")
