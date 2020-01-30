extends Node2D

var _match_started: = false

onready var match_time_left: Label = $GUI/Control/MatchTimeLeft
onready var start_message: Label = $GUI/Control/StartMessage
onready var match_timer: Timer = $MatchTimer


func _ready():
	match_time_left.hide()
	match_timer.connect("timeout", self, "_on_MatchTimer_timeout")


func _on_MatchTimer_timeout() -> void:
	end_match()


func _process(delta: float) -> void:
	match_time_left.text = "%.2f" % match_timer.time_left


func _input(event: InputEvent) -> void:
	if event is InputEventKey:
		if event.pressed:
			if not _match_started:
				start_match()


func start_match() -> void:
	_match_started = true

	start_message.hide()
	match_time_left.show()
	Event.emit_signal("Game_match_started")

	yield(Event, "Countdown_finished")

	match_timer.start()


func end_match() -> void:
	Event.emit_signal("Game_match_ended")
	match_time_left.hide()

	yield(get_tree().create_timer(2), "timeout")
	_match_started = false