extends Area2D
class_name PointArea

export var side: = ""


func _ready():
	connect("body_entered", self, "_on_body_entered")
	pass


func _on_body_entered(body: PhysicsBody2D) -> void:
	if body.is_in_group("Ball"):
		Event.emit_signal("scored", side)
	pass
