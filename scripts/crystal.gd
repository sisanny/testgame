extends Area2D

@onready var animation_player = $AnimationPlayer
@onready var hud = %HUD

func _on_body_entered(_body: Node2D) -> void:
	animation_player.play("pickup")
	hud.add_point()
