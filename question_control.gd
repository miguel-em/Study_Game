extends Control

# --- SIGNAL ---
signal quiz_finished(score: int)

# --- CONSTANTS ---
const QUESTIONS = [
	{"q": "Clearing of forests without suitable replanting causes?", "a": ["Enhanced biodiversity","Degradation of the soil and water", "Increase in local air quality ", "Rise in global ocean levels"], "correct": 1},
	{"q": "Deforestation can have a substantial long-term regional and global impact by?", "a": ["Decreasing the rate of glacial melting", "Increasing the number of local wildfires", "Increasing the amounts of carbon dioxide and methane","Reducing the average salinity of ocean water"], "correct": 2},
	{"q": "How does the impact of deforestation on global climate differ between tropical and boreal regions?", "a":["Tropical deforestation causes global warming, while boreal deforestation can cause cooling due to higher albedo from snow-covered ground","Both tropical and boreal deforestation lead to an identical increase in atmospheric methane, with no difference in global warming potential","Boreal deforestation causes global warming, while tropical deforestation causes regional cooling due to increased cloud cover","Tropical deforestation causes localized cooling, while boreal deforestation causes a uniform increase in global temperatures"], "correct": 0},
	{"q": "Why are biophysical effects important when studying deforestation?", "a": ["They are the primary drivers of insect migration and disease spread in deforested areas","They are only relevant in short-term studies and have negligible long-term global impact", "They determine the rate at which dead wood decays and releases methane into the soil", "They influence local temperature and rainfall, so forests help cool and stabilize the climate beyond just storing carbon"], "correct": 3},
	{"q": "What is one major consequence of tropical deforestation on the global climate?", "a": ["It decreases global temperatures by increasing the albedo of the ground","It increases global warming by releasing CO₂ and reducing natural cooling processes", "It drastically increases localized flooding in non-tropical", "It causes a significant reduction in atmospheric methane"], "correct": 1}
]

# --- VARIABLES ---
var current_question_index: int = 0
var saplings: int = 0

# --- NODES ---
@onready var question_label = $QText
@onready var answer_label = $Answer
@onready var button_a = $VBoxContainer/AnswerA
@onready var button_b = $VBoxContainer/AnswerB
@onready var button_c = $VBoxContainer/AnswerC
@onready var button_d = $VBoxContainer/AnswerD

# --- FUNCTIONS ---
func _ready() -> void:
	display_question(current_question_index)

func display_question(index: int):
	answer_label.text = "" 
	if index >= 0 and index < QUESTIONS.size():
		var q = QUESTIONS[index]
		question_label.text = q["q"]

		set_buttons_disabled(false)
		button_a.show()
		button_b.show()
		button_c.show()
		button_d.show()

		button_a.text = q["a"][0]
		button_b.text = q["a"][1]
		button_c.text = q["a"][2]
		button_d.text = q["a"][3]
	else:
		question_label.text = "Quiz Complete! You obtained %s saplings." % saplings
		answer_label.text = "Game Over"
		button_a.hide()
		button_b.hide()
		button_c.hide()
		button_d.hide()
		# 🔹 Emit final score to parent
		emit_signal("quiz_finished", saplings)

func next_question():
	current_question_index += 1
	display_question(current_question_index)

func set_buttons_disabled(disabled: bool):
	button_a.disabled = disabled
	button_b.disabled = disabled
	button_c.disabled = disabled
	button_d.disabled = disabled

func check_answer(choice: int) -> void:
	set_buttons_disabled(true)
	var q_data = QUESTIONS[current_question_index]
	var correct_index = q_data["correct"]

	if choice == correct_index:
		answer_label.text = "✅ Correct!"
		saplings += 1
	else:
		answer_label.text = "❌ Wrong!"

	await get_tree().create_timer(1.5).timeout
	next_question()

func _on_answer_a_pressed() -> void: check_answer(0)
func _on_answer_b_pressed() -> void: check_answer(1)
func _on_answer_c_pressed() -> void: check_answer(2)
func _on_answer_d_pressed() -> void: check_answer(3)
