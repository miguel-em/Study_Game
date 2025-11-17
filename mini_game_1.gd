extends Node2D

@onready var quiz_control = $mini_Quiz/QuestionControl
@onready var sapling_label = $Player/SaplingsLabel
@onready var points_label = $Player/PointsLabel

var player_saplings: int = 0

func _ready() -> void:
	# Hide quiz at start
	$mini_Quiz.hide()

	# Connect the quiz_finished signal
	quiz_control.connect("quiz_finished", Callable(self, "_on_quiz_finished"))

func _process(delta: float) -> void:
	pass

func _on_pop_up_close_requested() -> void:
	$MarginContainer/PopUp.hide()
	$mini_Quiz.show()

func _on_button_pressed() -> void:
	$MarginContainer/PopUp.show()

func _on_mini_quiz_close_requested() -> void:
	$mini_Quiz.hide()

func _on_quiz_finished(score: int) -> void:
	# Add saplings from quiz
	player_saplings += score
	_update_labels()
	$mini_Quiz.hide()


func _update_labels() -> void:
	sapling_label.text = "Saplings: %d" % player_saplings
	points_label.text = "Points: %d" % (player_saplings * 5)


func _on_button_1_pressed() -> void:
	if player_saplings > 0:
		$Sappling/SapplingNode3.show()
		player_saplings -= 1  # use one sapling
		_update_labels() # Replace with function body.



func _on_button_3_pressed() -> void:
	if player_saplings > 0:
		$Sappling/SapplingNode2.show()
		player_saplings -= 1  # use one sapling
		_update_labels()  # Replace with function body.



func _on_button_5_pressed() -> void:
	if player_saplings > 0:
		$Sappling/SapplingNode6.show()
		player_saplings -= 1  # use one sapling
		_update_labels()  # Replace with function body.


func _on_button_6_pressed() -> void:
	if player_saplings > 0:
		$Sappling/SapplingNode7.show()
		player_saplings -= 1  # use one sapling
		_update_labels()  # Replace with function body.


func _on_button_7_pressed() -> void:
	if player_saplings > 0:
		$Sappling/SapplingNode8.show()
		player_saplings -= 1  # use one sapling
		_update_labels()  # Replace with function body.


func _on_button_8_pressed() -> void:
	if player_saplings > 0:
		$Sappling/SapplingNode9.show()
		player_saplings -= 1  # use one sapling
		_update_labels()  # Replace with function body.


func _on_button_9_pressed() -> void:
	if player_saplings > 0:
		$Sappling/SapplingNode.show()
		player_saplings -= 1  # use one sapling
		_update_labels()  # Replace with function body.


func _on_button_10_pressed() -> void:
	if player_saplings > 0:
		$Sappling/SapplingNode10.show()
		player_saplings -= 1  # use one sapling
		_update_labels()  # Replace with function body.


func _on_button_2_pressed() -> void:
	if player_saplings > 0:
		$Sappling/SapplingNode4.show()
		player_saplings -= 1  # use one sapling
		_update_labels()  # Replace with function body.


func _on_button_4_pressed() -> void:
	if player_saplings > 0:
		$Sappling/SapplingNode5.show()
		player_saplings -= 1  # use one sapling
		_update_labels()  # Replace with function body.


func _on_go_home_pressed() -> void:
	get_tree().change_scene_to_file("res://scene/player_home.tscn") # Replace with function body.
