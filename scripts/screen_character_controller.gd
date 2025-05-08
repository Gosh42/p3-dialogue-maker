class_name CharacterController
extends Node

@onready var char_scene: PackedScene = preload("res://scenes/character_texture_rect.tscn")
@onready var character_container: Control = %Characters
var characters: Array[TextureRect]


func create_character() -> void:
	var new_char: TextureRect = char_scene.instantiate()
	characters.append(new_char)
	
	character_container.add_child(new_char)
	new_char.position.x = 256


func remove_last_character() -> void:
	character_container.remove_child(characters[-1])
	characters.resize(characters.size() - 1)


func set_sprite(index: int, image: Texture, eye_image: Texture) -> void:
	if index < len(characters):
		characters[index].texture = image
		
		var eyes: TextureRect = characters[index].get_child(0)
		eyes.texture = eye_image


func set_eye_height(index: int, eye_height: int) -> void:
	var eyes: TextureRect = characters[index].get_child(0)
	eyes.position.y = eye_height


func toggle_eyes(index: int, toggled_on: bool) -> void:
	(characters[index].get_child(0) as Control).visible = toggled_on


func set_flip(index: int, flip: bool) -> void:
	if index < len(characters):
		characters[index].flip_h = flip
		(characters[index].get_child(0) as TextureRect).flip_h = flip


func set_pos(index: int, pos: float) -> void:
	if index < len(characters):
		characters[index].position.x = pos


func set_vertical_pos(index: int, pos: float) -> void:
	if index < len(characters):
		characters[index].position.y = pos


func set_rotation(index: int, degrees: float) -> void:
	if index < len(characters):
		characters[index].rotation_degrees = degrees


func set_size(index: int, size: float) -> void:
	if index < len(characters):
		characters[index].scale = Vector2(size, size)
