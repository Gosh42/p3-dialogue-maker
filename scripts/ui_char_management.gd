extends Node

const character_ui: PackedScene = preload("res://scenes/ui_character_controls.tscn")
var character_controller: CharacterController

var count: int = 0

@onready var character_container: Control = %CharContainer


func _ready() -> void:
	var screen: ScreenControlGetter = %Screen
	character_controller = screen.get_character_controller()


func _on_character_added() -> void:
	var new_char: CharacterControllerUI = character_ui.instantiate()
	character_container.add_child(new_char)
	new_char.setup(character_controller, count)
	count += 1


func _on_character_removed() -> void:
	if count > 0:
		character_controller.remove_last_character()
		character_container.get_children()[-1].queue_free()
		count -= 1
