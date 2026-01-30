extends CanvasLayer

@onready var score_label = $Control/MarginContainer/HBoxContainer/Label
var score = 0

func add_point():
	score += 1
	score_label.text = str(score)
