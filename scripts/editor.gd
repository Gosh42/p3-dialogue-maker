extends Control

@onready var viewport_texture: TextureRect = %ViewportTexture
@onready var char_select: OptionButton = %CharSelection
@onready var screen: Screen = %Screen
@onready var dialogue_edit: TextEdit = %DialogueEdit


func _ready() -> void:
	pass


func _on_screenshot_btn_button_down() -> void:
	await RenderingServer.frame_post_draw
	
	var image: Image = viewport_texture.texture.get_image()
	image.save_png("res://images/yeah.png")


func _on_name_edit_text_changed(new_text: String) -> void:
	screen.set_name_text(new_text)


func _on_text_edit_text_changed() -> void:
	screen.set_dialogue_text(dialogue_edit.text)
