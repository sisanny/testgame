extends CanvasLayer

@onready var textbox_container = $TextboxContainer

var has_hidden_label = false

func _ready() -> void:
	set_process_input(true)

func _input(event: InputEvent) -> void:
	if has_hidden_label:
		return

	if event is InputEventKey and event.pressed and not event.echo:
		textbox_container.visible = false
		has_hidden_label = true
