extends Node

var dialogue: DialogueController

@onready var dialogue_edit: TextEdit = %DialogueEdit

@onready var choice_spin_box: SpinBox = %ChoiceSpinBox
@onready var quotes_check: CheckButton = %QuotesCheck
@onready var choice_3_edit: LineEdit = %Choice3Edit

# =================== INITIAL SETUP ====================== #

func _ready() -> void:
	var screen: ScreenControlGetter = %Screen
	dialogue = screen.get_dialogue_controller()
	
	dialogue.toggle_choice_textbox(false)
	dialogue.toggle_third_choice(false)
	dialogue.select_choice(0)
	dialogue.toggle_quotes(true)

# ====================== DIALOGUE BOX ====================== #

func _on_name_changed(new_text: String) -> void:
	dialogue.set_name_text(new_text)


func _on_dialogue_changed() -> void:
	dialogue.set_dialogue_text(dialogue_edit.text)


func _on_arrow_toggled(toggled_on: bool) -> void:
	dialogue.toggle_arrow(toggled_on)

# ====================== ANSWER BOX ====================== #

func _on_answer_toggled(toggled_on: bool) -> void:
	dialogue.toggle_choice_textbox(toggled_on)


func _on_third_choice_toggled(toggled_on: bool) -> void:
	var selection: int
	
	if toggled_on:
		choice_spin_box.max_value = 3
		selection = choice_spin_box.value
		choice_3_edit.show()
	else:
		choice_spin_box.max_value = 2
		
		selection = min(choice_spin_box.value, 2)
		choice_spin_box.value = selection
		choice_3_edit.hide()
	
	dialogue.toggle_third_choice(toggled_on)
	dialogue.select_choice(selection - 1)


func _on_selected_choice_changed(value: float) -> void:
	if value > choice_spin_box.max_value:
		choice_spin_box.value = choice_spin_box.min_value
	elif value < choice_spin_box.min_value:
		choice_spin_box.value = choice_spin_box.max_value
	else:
		dialogue.select_choice(int(value) - 1)


func _on_quotes_toggled(toggled_on: bool) -> void:
	dialogue.toggle_quotes(toggled_on)


func _on_choice_1_text_changed(new_text: String) -> void:
	dialogue.set_choice_text(0, new_text)


func _on_choice_2_text_changed(new_text: String) -> void:
	dialogue.set_choice_text(1, new_text)


func _on_choice_3_text_changed(new_text: String) -> void:
	dialogue.set_choice_text(2, new_text)
