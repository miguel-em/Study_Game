extends Node2D

@onready var sapling_sprite = $SapplingNode

func _ready() -> void:
	sapling_sprite.visible = false

func _on_static_body_2d_input_event(viewport, event, shape_idx) -> void:
	if event.is_action_pressed("plant"):
		var game = get_tree().get_root().get_node("res://scene/mini_game1.tscn")  # adjust path
		if game.player_saplings > 0 and !sapling_sprite.visible:
			sapling_sprite.visible = true
			game.player_saplings -= 1
			var label = game.get_node("Player/SaplingsLabel")
			label.text = "Saplings: %d" % game.player_saplings
