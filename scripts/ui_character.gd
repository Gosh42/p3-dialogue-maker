extends Node

@onready var screen: Screen = %Screen
@onready var char_select: OptionButton = %CharSelection
@onready var costume_select: OptionButton = %CostumeSelection
@onready var sprite_select: OptionButton = %SpriteSelection

var character_names: PackedStringArray
var costume_names: PackedStringArray

var sprite_images: Array[Texture]


func _ready() -> void:
	var dir: DirAccess = DirAccess.open("res://images/characters")
	
	# Adding characters
	character_names = dir.get_directories()
	
	for character: String in character_names:
		char_select.add_item(character.capitalize())
	
	char_select.select(0)
	_on_character_selected(0)


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
			
		for costume: String in costume_names:
			costume_select.add_item(costume.capitalize())
		
		print(costume_names)
		
		costume_select.select(0)
		_on_costume_selected(0)


func _on_costume_selected(index: int) -> void:
	sprite_select.clear()
	sprite_images.clear()
	
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
			sprite_images.append(load("res://images/characters/" + \
				character_names[char_select.selected] +  "/" + \
				costume_names[index] + "/" + sprite))
		
		sprite_select.select(0)
		_on_sprite_selected(0)


func _on_sprite_selected(index: int) -> void:
	screen.set_sprite(sprite_images[index])
