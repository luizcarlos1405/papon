extends Label

func _ready():
	show()
	text = ProjectSettings.get("global/start_message")
