class_name DialogueController
extends Node

@onready var name_label: Label = %NameLabel
@onready var dialogue_label: Label = %DialogueLabel
@onready var arrow: TextureRect = %Arrow

@onready var choice_box: Control = %TextboxChoice
@onready var selected_choice_bg: TextureRect = %ChoiceSelected
@onready var choice_label_1: Label = %Choice1
@onready var choice_label_2: Label = %Choice2
@onready var choice_label_3: Label = %Choice3

@onready var choices: Array[Label] = [choice_label_1, choice_label_2, choice_label_3]
var using_quotes_for_answers: bool = true
var choice_texts: Array[String] = ["Choice 1", "Choice 2", "Choice 3"]

const LABEL_RED: Color = Color(0x57171cff)
const LABEL_GREY: Color = Color(0x52525cff)
const LABEL_WHITE: Color = Color(0xdfdfffff)


func set_name_text(text: String) -> void:
	name_label.text = text


func set_dialogue_text(text: String) -> void:
	dialogue_label.text = text


func toggle_arrow(toggled_on: bool) -> void:
	arrow.visible = toggled_on


func toggle_choice_textbox(toggled_on: bool) -> void:
	choice_box.visible = toggled_on
	var opacity: float
	
	if toggled_on:
		name_label.label_settings.font_color = LABEL_GREY
		opacity = 0.5
	else:
		name_label.label_settings.font_color = LABEL_RED
		opacity = 1
		
	name_label.modulate.a = opacity
	dialogue_label.modulate.a = opacity


func select_choice(choice_i: int) -> void:
	for choice: Label in choices:
		choice.label_settings.font_color = LABEL_GREY
	
	choices[choice_i].label_settings.font_color = LABEL_WHITE
	
	selected_choice_bg.position.y = choices[choice_i].position.y - 4


func toggle_third_choice(toggled_on: bool) -> void:
	if toggled_on:
		choice_label_1.position.y = 35
		choice_label_2.position.y = 59
		choice_label_3.show()
	else:
		choice_label_1.position.y = 40
		choice_label_2.position.y = 77
		choice_label_3.hide()


func toggle_quotes(toggled_on: bool) -> void:
	using_quotes_for_answers = toggled_on
	for i: int in [0, 1, 2]:
		set_choice_text(i, choice_texts[i])


func set_choice_text(choice_i: int, text: String) -> void:
	choice_texts[choice_i] = text
	if using_quotes_for_answers:
		choices[choice_i].text = "”" + text + "”"
	else:
		choices[choice_i].text = text
