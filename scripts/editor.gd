extends Control

@onready var viewport_texture: TextureRect = %ViewportTexture
@onready var char_select: OptionButton = %CharSelection

@onready var screen: Screen = %Screen
@onready var dialogue_edit: TextEdit = %DialogueEdit

@onready var time_select: OptionButton = %TimeSelection
@onready var month_spin_box: SpinBox = %MonthSpinBox
@onready var day_spin_box: SpinBox = %DaySpinBox

@onready var day_colour_select: OptionButton = %DayColourSelection

var custom_colour: Color = Color.WHITE
var colour_index: int = 0


func _ready() -> void:
	pass


func _on_screenshot_btn_button_down() -> void:
	await RenderingServer.frame_post_draw
	
	var image: Image = viewport_texture.texture.get_image()
	image.save_png("res://images/yeah.png")

# =================== NAME AND DIALOGUE ====================== #

func _on_name_edit_text_changed(new_text: String) -> void:
	screen.set_name_text(new_text)


func _on_text_edit_text_changed() -> void:
	screen.set_dialogue_text(dialogue_edit.text)

func _on_arrow_check_toggled(toggled_on: bool) -> void:
	screen.toggle_arrow(toggled_on)

# =================== TIME SELECTION ====================== #

func _on_time_selected(index: int) -> void:
	screen.set_daytime(index)
	
	if index == 9: # dark hour
		colour_index = day_colour_select.selected
		day_colour_select.select(3)
	else:
		day_colour_select.select(colour_index)


func _on_month_changed(value: float) -> void:
	if value > month_spin_box.max_value:
		month_spin_box.value = month_spin_box.min_value
	elif value < month_spin_box.min_value:
		month_spin_box.value = month_spin_box.max_value
	else:
		screen.set_month(value)


func _on_day_changed(value: float) -> void:
	if value > day_spin_box.max_value:
		day_spin_box.value = day_spin_box.min_value
	elif value < day_spin_box.min_value:
		day_spin_box.value = day_spin_box.max_value
	else:
		screen.set_day(value)

# =================== COLOUR SELECTION ====================== #

func _on_day_colour_selected(index: int) -> void:
	colour_index = index
	# last always will be custom. this is a bad way to do this but i don't care
	if index < day_colour_select.item_count - 1:
		screen.choose_colour(index)
	else:
		screen.set_custom_colour(custom_colour)


func _on_day_colour_picked(colour: Color) -> void:
	custom_colour = colour
	
	if day_colour_select.selected == day_colour_select.item_count - 1:
		screen.set_custom_colour(custom_colour)
