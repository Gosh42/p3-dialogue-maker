class_name Screen
extends Control

@onready var name_label: Label = %NameLabel
@onready var dialogue_label: Label = %DialogueLabel


func set_name_text(str: String) -> void:
	name_label.text = str


func set_dialogue_text(str: String) -> void:
	dialogue_label.text = str
