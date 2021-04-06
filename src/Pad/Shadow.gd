extends Sprite


func _ready() -> void:
	set_as_toplevel(true)

	global_position = owner.global_position + Vector2(5, 5)
	rotation = owner.rotation
	visible = owner.visible
	flip_h = get_parent().flip_h
	pass


func _process(delta: float) -> void:
	if (owner.get_parent()):
		modulate = owner.get_parent().modulate
		scale = owner.get_parent().scale

	global_position = owner.global_position + Vector2(5, 5)
	rotation = owner.rotation
	visible = owner.visible
	modulate = owner.modulate
	flip_h = get_parent().flip_h
