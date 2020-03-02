extends Node2D

var state: int = Enum.GameState.PRE_GAME setget set_state

onready var match_time_left: Label = $GUI/Control/MatchTimeLeft
onready var start_message: Label = $GUI/Control/StartMessage
onready var match_timer: Timer = $MatchTimer
onready var score: Label = $GUI/Control/ScoreAxis/Score
onready var pause: TextureButton = $GUI/Control/Pause


func _ready():
	match_time_left.hide()
	match_timer.connect("timeout", self, "_on_MatchTimer_timeout")
	Event.connect("match_start_requested", self, "_on_Event_match_start_requested")


func _on_MatchTimer_timeout() -> void:
	end_match()


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
	match_time_left.text = "%.2f" % match_timer.time_left


func _input(event: InputEvent) -> void:
	if event is InputEventKey or event is InputEventScreenTouch:
		if event.pressed:
			match state:
				Enum.GameState.PRE_GAME, Enum.GameState.POS_GAME:
					if score.animation_player.is_playing():
						return

					Event.emit_signal("match_start_requested")


func start_match() -> void:
	start_message.hide()
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
