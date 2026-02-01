extends Area2D

@export var dialog_title: String = "Enter your text:"

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var collider: CollisionShape2D = $CollisionShape2D
@onready var crystal: Area2D = $Crystal

@onready var dialog: AcceptDialog = get_tree().current_scene.get_node("CanvasLayer/NameDialog")
@onready var title: Label = dialog.find_child("TitleLabel", true, false) as Label
@onready var input_any: Node = dialog.find_child("NameInput", true, false)

var opened := false
var waiting_for_submit := false
var player_ref: CharacterBody2D = null
var dialog_open := false


func _ready() -> void:
	add_to_group("treasureboxes")
	# Chest starts visible/closed
	sprite.stop()
	sprite.frame = 0
	sprite.modulate.a = 1.0

	# Crystal starts hidden + not pickable
	crystal.visible = false
	crystal.set_deferred("monitoring", false)
	crystal.set_deferred("monitorable", false)

	if not sprite.animation_finished.is_connected(_on_open_anim_finished):
		sprite.animation_finished.connect(_on_open_anim_finished)
	
	# Connect the 
	if input_any is TextEdit:
		var te := input_any as TextEdit
		if not te.gui_input.is_connected(_on_text_input_gui_input):
			te.gui_input.connect(_on_text_input_gui_input)

func _on_body_entered(body: Node2D) -> void:
	if opened or waiting_for_submit:
		return
	if not body.is_in_group("player"):
		return

	# Check if works with CharacterBody2D 
	# Cast to your player (so can_move always exists)
	player_ref = body as CharacterBody2D
	if player_ref == null:
		return

	waiting_for_submit = true

	# Freeze player
	player_ref.set("can_move", false)
	player_ref.velocity = Vector2.ZERO

	# Small push away from the box (push left or right depending on side)
	if player_ref.global_position.x < global_position.x:
		player_ref.global_position.x -= 8
	else:
		player_ref.global_position.x += 8

	dialog.confirmed.connect(_on_submit, CONNECT_ONE_SHOT)
	dialog.canceled.connect(_on_cancel, CONNECT_ONE_SHOT)
	
	if title:
		title.text = dialog_title
	
	_set_input_text("")

	dialog_open = true
	dialog.popup_centered()
	await get_tree().process_frame
	_grab_input_focus()

func _on_submit() -> void:
	# Unfreeze player
	if player_ref:
		player_ref.set("can_move", true)
		player_ref = null

	waiting_for_submit = false

	dialog_open = false

	dialog.hide()
	open_box()

func _on_cancel() -> void:
	# Unfreeze player (same as submit but no box opening)
	if player_ref:
		player_ref.set("can_move", true)
		player_ref = null
	
	waiting_for_submit = false
	dialog_open = false
	dialog.hide()

func open_box() -> void:
	if opened:
		return
	opened = true

	collider.disabled = true
	sprite.play("open")

func _on_open_anim_finished() -> void:
	if sprite.animation != "open":
		return

	# Fade chest out, then reveal crystal + remove chest parts
	var t := create_tween()
	t.tween_property(sprite, "modulate:a", 0.0, 1.0)
	t.tween_callback(func():
		crystal.visible = true
		crystal.set_deferred("monitoring", true)
		crystal.set_deferred("monitorable", true)

		collider.queue_free()
		sprite.queue_free()
	)

# --- helpers for TextEdit ---
func _get_input_text() -> String:
	if input_any == null:
		return ""
	if input_any is TextEdit:
		return (input_any as TextEdit).text
	if input_any is LineEdit:
		return (input_any as LineEdit).text
	return ""

func _set_input_text(value: String) -> void:
	if input_any == null:
		return
	if input_any is TextEdit:
		(input_any as TextEdit).text = value
	elif input_any is LineEdit:
		(input_any as LineEdit).text = value

func _grab_input_focus() -> void:
	if input_any == null:
		return
	if input_any is TextEdit:
		(input_any as TextEdit).grab_focus()
	elif input_any is LineEdit:
		(input_any as LineEdit).grab_focus()
		
		
# Add ctrl + enter for submit 
func _on_text_input_gui_input(event: InputEvent) -> void:
	if not dialog_open:
		return

	if event is InputEventKey and event.pressed and not event.echo:
		var k := event as InputEventKey
		if k.ctrl_pressed and (k.keycode == KEY_ENTER or k.keycode == KEY_KP_ENTER):
			# Trigger the same logic as clicking OK
			dialog.confirmed.emit()
			get_viewport().set_input_as_handled()
