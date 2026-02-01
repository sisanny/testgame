extends Area2D

@onready var animation_player = $AnimationPlayer
@onready var hud = get_tree().current_scene.find_child("HUD", true, false)

func _on_body_entered(_body: Node2D) -> void:
	animation_player.play("pickup")
	hud.add_point()

func _ready() -> void:
	visible = false
	monitoring = false
