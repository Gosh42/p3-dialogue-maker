class_name ScreenControlGetter
extends Node


func get_character_controller() -> CharacterController:
	return $CharacterController


func get_dialogue_controller() -> DialogueController:
	return $DialogueController


func get_corner_controller() -> CornerController:
	return $CornerController
