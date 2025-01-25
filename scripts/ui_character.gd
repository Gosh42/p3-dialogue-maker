class_name CharacterControllerUI
extends Node

var char_ctrl: CharacterController
var current: int

@onready var char_select: OptionButton
@onready var costume_select: OptionButton
@onready var sprite_select: OptionButton

@onready var position_slider: HSlider
@onready var flip_check: CheckButton

var character_names: PackedStringArray
var costume_names: PackedStringArray

var sprite_images: Array[Texture]
var eye_images: Array[Texture]
var eye_height: int

# ====================== SETUP AND REMOVAL ====================== #

# Workaround of not finding nodes before the class instance is added to a tree
func setup(character_controller: CharacterController, index: int) -> void:
	char_ctrl = character_controller
	current = index
	# Assigning node references
	char_select = $CharSelection
	costume_select = $CostumeSelection
	sprite_select = $SpriteSelection
	position_slider = $PositionSlider
	flip_check = $FlipCheck
	
	# Adding characters
	var dir: DirAccess = DirAccess.open("res://images/characters")
	
	character_names = dir.get_directories()
	
	for character: String in character_names:
		char_select.add_item(character.capitalize())
	
	char_ctrl.create_character()
	
	print("yeah!!")
	char_select.select(0)
	_on_character_selected(0)


# ====================== CHARACTER SELECTION ====================== #

func _on_character_selected(index: int) -> void:
	costume_names.clear()
	costume_select.clear()
	
	var path: String = "res://images/characters/" + character_names[index]
	var dir: DirAccess = DirAccess.open(path)
	
	if dir:
		if dir.file_exists("order.txt"):
			var file: FileAccess = FileAccess.open(path + "/order.txt", FileAccess.READ)
			while not file.eof_reached():
				var line: String = file.get_line()
				costume_names.append(line)
			file.close()
		else:
			costume_names = dir.get_directories()
		
		if dir.file_exists("eye_height.txt"):
			var file: FileAccess = FileAccess.open(path + "/eye_height.txt", FileAccess.READ)
			eye_height = int(file.get_line())
		else:
			eye_height = 110
		
		char_ctrl.set_eye_height(current, eye_height)
		
		for costume: String in costume_names:
			costume_select.add_item(costume.capitalize())
		
		costume_select.select(0)
		costume_select.visible = costume_select.item_count > 1
		_on_costume_selected(0)


func _on_costume_selected(index: int) -> void:
	sprite_select.clear()
	sprite_images.clear()
	eye_images.clear()
	
	var path: String = "res://images/characters/" + \
		character_names[char_select.selected] + "/" + costume_names[index]
	var dir: DirAccess = DirAccess.open(path)
	
	if dir:
		var sprite_names: PackedStringArray
		if dir.file_exists("order.txt"):
			var file: FileAccess = FileAccess.open(path + "/order.txt", FileAccess.READ)
			while not file.eof_reached():
				var line: String = file.get_line()
				sprite_names.append(line)
			file.close()
		else:
			for sprite: String in dir.get_files():
				if not (sprite.ends_with(".import") or sprite.ends_with("-.png")):
					sprite_names.append(sprite)
		
		for sprite: String in sprite_names:
			sprite_select.add_item(sprite.get_basename().capitalize())
			
			var base_path: String = "res://images/characters/" + \
				character_names[char_select.selected] +  "/" + \
				costume_names[index] + "/"
			var eye_path: String = base_path + sprite.get_basename() + "-." + \
				sprite.get_extension()
				
			sprite_images.append(load(base_path + sprite))
			if ResourceLoader.exists(eye_path):
				eye_images.append(load(eye_path))
			else:
				eye_images.append(null)
			
			print(len(sprite_images), " ", len(eye_images))
		
		sprite_select.select(0)
		sprite_select.visible = sprite_select.item_count > 1
		_on_sprite_selected(0)


func _on_sprite_selected(index: int) -> void:
	char_ctrl.set_sprite(current, sprite_images[index], eye_images[index])

# ====================== POSITIONING ====================== #

func _on_position_changed(value: float) -> void:
	char_ctrl.set_pos(current, value)


func _on_position_snapped(value: float) -> void:
	position_slider.value = value
	flip_check.button_pressed = value < 0


func _on_flip_toggled(toggled_on: bool) -> void:
	char_ctrl.set_flip(current, toggled_on)


func _on_eyes_toggled(toggled_on: bool) -> void:
	char_ctrl.toggle_eyes(current, toggled_on)
