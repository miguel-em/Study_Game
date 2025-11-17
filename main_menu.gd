extends Control

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_Startbutton_pressed() -> void:
	get_tree().change_scene_to_file("res://scene/player_home.tscn") # Replace with function body.

func _on_Aboutbutton_3_pressed() -> void:
	$Window.show() # Replace with function body.


func _on_Exitbutton_2_pressed() -> void:
	get_tree().quit() # Replace with function body.


func _on_window_close_requested() -> void:
	$Window.hide() # Replace with function body.
