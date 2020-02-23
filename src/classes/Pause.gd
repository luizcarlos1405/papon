extends TextureButton

const Game: = preload("res://src/Game/Game.gd")

export var menu_path: = NodePath()

onready var game: Game = owner


func _ready():
	hide()
	Event.connect("Game_state_changed", self, '_on_Event_Game_state_changed')
	connect("toggled", self, "_on_toggled")
	pass


func _on_Event_Game_state_changed(to: int) -> void:
	match to:
		Enum.GameState.POS_GAME, Enum.GameState.PRE_GAME:
			hide()

		_:
			show()


func _on_toggled(is_pressed: bool) -> void:
	var menu: Popup = get_node(menu_path)

	get_tree().paused = is_pressed

	if menu:
		menu.set_visible(is_pressed)
