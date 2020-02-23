extends Popup

const Game: = preload("Game.gd")

export(String, FILE, "*.tscn") var MainMenuScnPath: = ""

onready var back: Button = $VBoxContainer/Back
onready var restart: Button = $VBoxContainer/Restart
onready var game: Game = owner


func _ready():
	Event.connect("Game_state_changed", self, "_on_Event_Game_state_changed")
	back.connect("pressed", self, "_on_Back_pressed")
	restart.connect("pressed", self, "_on_Restart_pressed")


func _on_Event_Game_state_changed(to: int) -> void:
	match to:
		Enum.GameState.POS_GAME:
			popup()
		_:
			hide()


func _on_Back_pressed() -> void:
	if MainMenuScnPath:
		get_tree().paused = false
		get_tree().change_scene_to(load(MainMenuScnPath))
	pass


func _on_Restart_pressed() -> void:
	Event.emit_signal("match_start_requested")
	hide()
	pass
