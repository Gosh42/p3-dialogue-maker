extends Node

var corner_ctrl: CornerController

@onready var time_select: OptionButton = %TimeSelection
@onready var month_spin_box: SpinBox = %MonthSpinBox
@onready var day_spin_box: SpinBox = %DaySpinBox
@onready var weekday_select: OptionButton = %WeekdaySelection

@onready var day_colour_select: OptionButton = %DayColourSelection
var custom_colour: Color = Color.WHITE
var colour_index: int = 0

# ====================== INITIAL SETUP ====================== #

func _ready() -> void:
	var screen: ScreenControlGetter = %Screen
	corner_ctrl = screen.get_corner_controller()
	
	# Setting date and weekday based on system date
	
	var time_dict: Dictionary = Time.get_datetime_dict_from_system()
	
	var month: int = time_dict["month"]
	month_spin_box.value = month
	corner_ctrl.set_month(month)
	
	var day: int = time_dict["day"]
	day_spin_box.value = day
	corner_ctrl.set_day(day)
	
	var weekday: int = time_dict["weekday"]
	weekday = wrapi(weekday - 1, 0, 6)
	weekday_select.select(weekday)
	corner_ctrl.set_weekday(weekday)
	
	# Picking a time label based on system time
	
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
	corner_ctrl.set_daytime(hour_index)
	
	# Setting the moon phase to whatever because I can't be bothered
	# to come up with a good way to "calculate" it
	corner_ctrl.set_moon_phase(randi() % 31)

# ====================== DATE AND TIME ====================== #

func _on_corner_toggled(toggled_on: bool) -> void:
	corner_ctrl.toggle_corner(toggled_on)
	

func _on_time_selected(index: int) -> void:
	corner_ctrl.set_daytime(index)
	
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
		
		corner_ctrl.set_month(value)


func _on_day_changed(value: float) -> void:
	if value > day_spin_box.max_value:
		day_spin_box.value = day_spin_box.min_value
	elif value < day_spin_box.min_value:
		day_spin_box.value = day_spin_box.max_value
	else:
		corner_ctrl.set_day(value)


func _on_weekday_selected(index: int) -> void:
	var is_question_mark: bool = index != 7
	month_spin_box.editable = is_question_mark
	day_spin_box.editable = is_question_mark
	
	corner_ctrl.set_weekday(index)


func _on_holiday_toggled(toggled_on: bool) -> void:
	corner_ctrl.set_holiday(toggled_on)


func _on_moon_phase_changed(value: float) -> void:
	corner_ctrl.set_moon_phase(30 - value)

# ====================== COLOUR SELECTION ====================== #

func _on_day_colour_selected(index: int) -> void:
	colour_index = index
	# Last always will be custom. Probably a bad way to do this but I don't care
	if index < day_colour_select.item_count - 1:
		corner_ctrl.choose_colour(index)
	else:
		corner_ctrl.set_custom_colour(custom_colour)


func _on_day_colour_picked(colour: Color) -> void:
	custom_colour = colour
	
	if day_colour_select.selected == day_colour_select.item_count - 1:
		corner_ctrl.set_custom_colour(custom_colour)
