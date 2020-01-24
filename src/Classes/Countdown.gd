extends Label
class_name Countdown

signal finished

export var duration: = 3

var tween: = Tween.new()
var tween_trans: = Tween.TRANS_EXPO
var tween_ease: = Tween.EASE_IN

var _time_left: = duration


func _ready() -> void:
	hide()
	add_child(tween)

	tween.connect("tween_all_completed", self, "_on_Tween_tween_all_completed")


func _on_Tween_tween_all_completed() -> void:
	_time_left -= 1

	if _time_left == 0:
		emit_signal("finished")

	elif _time_left < 0:
		hide()
		return

	animate()

	text = _time_left as String


func animate() -> void:
	tween.interpolate_property(
		self,
		"rect_scale",
		Vector2(1, 1),
		Vector2(0, 0),
		1,
		tween_trans,
		tween_ease
	)
	tween.interpolate_property(
		self,
		"self_modulate",
		Color(1, 1, 1, 1),
		Color(1, 1, 1, 0),
		1,
		tween_trans,
		tween_ease
	)

	tween.start()


func start() -> void:
	reset()
	show()
	animate()


func reset() -> void:
	_time_left = duration
	text = _time_left as String
