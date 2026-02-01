extends CanvasLayer

func _ready() -> void:
	# Optionally, pause the game while on this screen
	get_tree().paused = true
	# But allow this scene to keep processing input
	process_mode = Node.PROCESS_MODE_ALWAYS

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept"): # e.g. Enter/Space
		_go_to_next_level()

func _go_to_next_level() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/wellbeing_game_level_2.tscn")
