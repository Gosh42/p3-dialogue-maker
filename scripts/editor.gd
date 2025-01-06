extends Control

@onready var viewport_texture: TextureRect = %ViewportTexture
@onready var char_select: OptionButton = %CharSelection

@onready var screen: Screen = %Screen
@onready var dialogue_edit: TextEdit = %DialogueEdit

@onready var choice_spin_box: SpinBox = %ChoiceSpinBox
@onready var quotes_check: CheckButton = %QuotesCheck
@onready var choice_3_edit: LineEdit = %Choice3Edit

@onready var time_select: OptionButton = %TimeSelection
@onready var month_spin_box: SpinBox = %MonthSpinBox
@onready var day_spin_box: SpinBox = %DaySpinBox
@onready var weekday_select: OptionButton = %WeekdaySelection

@onready var day_colour_select: OptionButton = %DayColourSelection

var custom_colour: Color = Color.WHITE
var colour_index: int = 0


func _ready() -> void:
	var time_dict: Dictionary = Time.get_datetime_dict_from_system()
	
	screen.toggle_choice_textbox(false)
	screen.toggle_third_choice(false)
	screen.select_choice(0)
	screen.toggle_quotes(true)
	
	var month: int = time_dict["month"]
	month_spin_box.value = month
	screen.set_month(month)
	
	var day: int = time_dict["day"]
	day_spin_box.value = day
	screen.set_day(day)
	
	var weekday: int = time_dict["weekday"]
	weekday = wrapi(weekday - 1, 0, 6)
	weekday_select.select(weekday)
	screen.set_weekday(weekday)
	
	# time label ("Afternoon", etc)
	var hour: int = time_dict["hour"]
	var minutes: int = time_dict["minute"]
	var hour_index: int = -1
	
	if minutes == 0 and (hour == 0 or hour == 24):
		hour_index = 9 # dark hour
	else:
		for i: int in [4, 6, 8, 10, 12, 13, 15, 18, 23]:
			hour_index += int(hour >= i)
		
		if hour_index == -1:
			hour_index = 8
	
	time_select.select(hour_index)
	screen.set_daytime(hour_index)
	screen.set_moon_phase(30)


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


func _on_answer_toggled(toggled_on: bool) -> void:
	screen.toggle_choice_textbox(toggled_on)


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
	
	screen.toggle_third_choice(toggled_on)
	screen.select_choice(selection - 1)


func _on_selected_choice_changed(value: float) -> void:
	if value > choice_spin_box.max_value:
		choice_spin_box.value = choice_spin_box.min_value
	elif value < choice_spin_box.min_value:
		choice_spin_box.value = choice_spin_box.max_value
	else:
		screen.select_choice(int(value) - 1)



func _on_quotes_toggled(toggled_on: bool) -> void:
	screen.toggle_quotes(toggled_on)



func _on_choice_1_text_changed(new_text: String) -> void:
	screen.set_choice_text(0, new_text)


func _on_choice_2_text_changed(new_text: String) -> void:
	screen.set_choice_text(1, new_text)


func _on_choice_3_text_changed(new_text: String) -> void:
	screen.set_choice_text(2, new_text)

# =================== TIME SELECTION ====================== #

func _on_time_selected(index: int) -> void:
	screen.set_daytime(index)
	
	if index == 9: # dark hour
		colour_index = day_colour_select.selected
		day_colour_select.select(3)
	else:
		day_colour_select.select(colour_index)


func _on_month_changed(val: float) -> void:
	var value: int = int(val)
	if value > month_spin_box.max_value:
		month_spin_box.value = month_spin_box.min_value
	elif value < month_spin_box.min_value:
		month_spin_box.value = month_spin_box.max_value
	else:
		if value in [1, 3, 5, 7, 8, 10, 12]:
			day_spin_box.max_value = 31
		elif value in [4, 6, 9, 11]:
			day_spin_box.value = mini(day_spin_box.value, 30)
			day_spin_box.max_value = 30
		else: # february
			day_spin_box.value = mini(day_spin_box.value, 29)
			day_spin_box.max_value = 29
		
		screen.set_month(value)


func _on_day_changed(value: float) -> void:
	if value > day_spin_box.max_value:
		day_spin_box.value = day_spin_box.min_value
	elif value < day_spin_box.min_value:
		day_spin_box.value = day_spin_box.max_value
	else:
		screen.set_day(value)


func _on_weekday_selected(index: int) -> void:
	var is_question_mark: bool = index != 7
	month_spin_box.editable = is_question_mark
	day_spin_box.editable = is_question_mark
	
	screen.set_weekday(index)


func _on_holiday_toggled(toggled_on: bool) -> void:
	screen.set_holiday(toggled_on)


func _on_moon_phase_changed(value: float) -> void:
	screen.set_moon_phase(30 - value)

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
