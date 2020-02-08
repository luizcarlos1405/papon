extends ShakyCamera

export(float, 0, 1) var scored_trauma: = 1.0
export(float, 0, 1) var ball_hit_pad_trauma: = 0.35

func _ready():
	Event.connect("Ball_hit_pad", self, "_on_Event_Ball_hit_pad")
	Event.connect("scored", self, "_on_Event_scored")
	pass


func _on_Event_scored(side: String) -> void:
	self.trauma = scored_trauma


func _on_Event_Ball_hit_pad() -> void:
	self.trauma = ball_hit_pad_trauma
