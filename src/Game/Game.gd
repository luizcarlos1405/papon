extends Node2D

var state: int = Enum.GameState.PRE_GAME setget set_state

onready var match_time_left: Label = $GUI/Control/MatchTimeLeft
onready var match_timer: Timer = $MatchTimer
onready var score: Label = $GUI/Control/ScoreAxis/Score
onready var pause: TextureButton = $GUI/Control/Pause


func _ready():
	match_time_left.hide()
	match_timer.connect("timeout", self, "_on_MatchTimer_timeout")
	Event.connect("match_start_requested", self, "_on_Event_match_start_requested")
	Event.connect("won_by_score", self, "_on_Event_won_by_score")
	Event.connect("scored", self, "_on_Event_scored")

	$AnimationPlayer.seek(0)


func _on_MatchTimer_timeout() -> void:
	end_match()


func _on_Event_won_by_score() -> void:
	end_match()


func _on_Event_scored(side: String) -> void:
	$Sfx/Scored.play()


func _on_Event_match_start_requested() -> void:
	match state:
		Enum.GameState.PRE_GAME:
			score.show()
			start_match()

		Enum.GameState.POS_GAME:
			score.reset()
			yield(score.animation_player, "animation_finished")
			start_match()


func _process(delta: float) -> void:
	match_time_left.text = "%d" % ceil(match_timer.time_left)


func _input(event: InputEvent) -> void:
	if event is InputEventKey or event is InputEventScreenTouch:
		if event.pressed:
			match state:
				Enum.GameState.PRE_GAME:
					if score.animation_player.is_playing():
						return

					$AnimationPlayer.play("start-game")

				Enum.GameState.POS_GAME:
					if score.animation_player.is_playing():
						return

					$GUI/Control/Countdown.start()


func start_match() -> void:
	match_time_left.show()

	set_state(Enum.GameState.IN_GAME)

	yield(Event, "Countdown_finished")

	match_timer.start()


func end_match() -> void:
	match_time_left.hide()
	score.show_result()

	set_state(Enum.GameState.POS_GAME)


func set_state(value: int) -> void:
	state = value

	Event.emit_signal("Game_state_changed", state)
