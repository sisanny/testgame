extends Area2D

var max_score: int = 5
@onready var interaction_label = $InteractionLabel
@onready var info_container = $InfoContainer
@onready var info_label = $InfoContainer/PanelContainer/MarginContainer/InfoLabel
@onready var hud = %HUD

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	interaction_label.visible = false
	info_container.visible = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if interaction_label.visible == true && Input.is_action_just_pressed("interact"):
		_on_interact()

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		interaction_label.visible = true

func _on_body_exited(body: Node2D) -> void:
	if body is Player:
		interaction_label.visible = false
		info_container.visible = false
  
func _on_interact() -> void:
	if hud.score < max_score:
		var crystals_left :int = max_score - hud.score
		var crystal_word := "crystal" if crystals_left == 1  else "crystals"
		info_label.text = "You need %d more %s to use this portal." % [crystals_left, crystal_word]
		
		info_container.visible = true
		interaction_label.visible = false
	else:
		info_container.visible = false
		interaction_label.visible = false
		print("player entered portal")
