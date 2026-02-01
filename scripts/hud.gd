extends CanvasLayer

@onready var score_label = $Control/MarginContainer/HBoxContainer/Label

var score: int = 0
var max_score: int = 0

func _ready() -> void:
	await get_tree().process_frame
	_init_max_score()

func _init_max_score() -> void:
	var treasureboxes := get_tree().get_nodes_in_group("treasureboxes")
	max_score = treasureboxes.size()

func add_point():
	score += 1
	score_label.text = str(score)
