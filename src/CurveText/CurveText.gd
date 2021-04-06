tool
extends Node2D

class_name CurveText

export var text: = "Text" setget set_text
export var center: = Vector2() setget set_center
export var letter_spacing: = 0.0 setget set_letter_spacing
export var color: = Color(1,1,1,1) setget set_color
export var use_global_position: = false

export var custom_font: Font = Label.new().get_font("font") setget set_custom_font

var center_text_offset : float = 0
var text_length :float = text.length()
var text_width
var char_directions := []

func _enter_tree():
	if get_name() == "Node2D":
		set_name("CurveText")
	pass

func _ready():
	set_text(text)
#	set_as_toplevel(true)

	if not custom_font:
		custom_font = Label.new().get_font("font")

func _process(delta):
	update()
	pass

func _draw():
	var reference: = position if not use_global_position else global_position
	var direction: = reference - center

	if not direction : return

	var radius : float = direction.length()
	var direction_offset = Vector2(1.0, 0.0)
	direction = direction.normalized()

	var dir = Vector2(1.0, 0.0)
	for i in range(text_length):
		var char_offset : float = custom_font.get_string_size(text[i]).x/2.0

		dir = dir.rotated(char_offset/radius)
		char_directions[i] = direction.rotated(dir.angle())
		dir = dir.rotated((char_offset + letter_spacing)/radius)

	for i in char_directions.size():
		char_directions[i] = char_directions[i].rotated(-dir.angle() / 2)
		pass

	# Draw outline
#	for i in range(text_length):
#		var char_offset : float = custom_font.get_string_size(text[i]).x/2.0
#
#		draw_set_transform((char_directions[i] - direction) * radius, char_directions[i].angle() + PI/2, Vector2(1,1))
#		custom_font.draw_char(get_canvas_item(), Vector2(-char_offset, 0), text.to_ascii()[i], -1, Color(1, 1, 1, 1), true)

	# Draw characters
	for i in range(text_length):
		var char_offset : float = custom_font.get_string_size(text[i]).x/2.0

		draw_set_transform((char_directions[i] - direction) * radius, char_directions[i].angle() + PI/2, Vector2(1,1))
		draw_char(custom_font, Vector2(-char_offset, 0), text[i], "", color)

	# ISSO AQUI É 560% GAMBIARRA, MAS TA FUNCIONANDO E É SÓ ESSA LINHA
	# O código já corrige a rotação em relação ao centro então eu compenso a
	# rotação herdada pelo pai. No entanto é desejável manter a translação
	# herdada pelo pai. Daí essa gambiarra aqui
#	set_rotation(-get_parent().get_global_transform().get_rotation())


func set_text(to):
	text = to
	text_length = text.length()
	text_width = custom_font.get_string_size(text)
	char_directions.resize(text_length)
	update()


func set_center(to):
	center = to
	update()


func set_letter_spacing(to):
	letter_spacing = to
	update()


func set_custom_font(to):
	custom_font = to
	update()


func set_color(to):
	color = to
	update()
