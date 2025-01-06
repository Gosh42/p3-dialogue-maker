class_name Screen
extends Control

@onready var name_label: Label = %NameLabel
@onready var dialogue_label: Label = %DialogueLabel
@onready var arrow: TextureRect = %Arrow

@onready var choice_box: Control = %TextboxChoice
@onready var selected_choice_bg: TextureRect = %ChoiceSelected
@onready var choice_label_1: Label = %Choice1
@onready var choice_label_2: Label = %Choice2
@onready var choice_label_3: Label = %Choice3

@onready var choices: Array[Label] = [choice_label_1, choice_label_2, choice_label_3]
var using_quotes_for_answers: bool = true
var choice_texts: Array[String] = ["Choice 1", "Choice 2", "Choice 3"]

@onready var corner: TextureRect = %Main

@onready var month_tens: TextureRect = %MonthTens
@onready var month_ones: TextureRect = %MonthOnes
@onready var slash: TextureRect = %Slash
@onready var day_tens: TextureRect = %DayTens
@onready var day_ones: TextureRect = %DayOnes
@onready var dot: TextureRect = %Dot
@onready var weekday: TextureRect = %Weekday

@onready var daytime_sprite: Sprite2D = %DaytimeSprite

@onready var next_tens: TextureRect = %NextTens
@onready var next_ones: TextureRect = %NextOnes
@onready var moon_phase_controller: AnimationPlayer = %MoonPhase

const LABEL_RED: Color = Color(0x57171cff)
const LABEL_GREY: Color = Color(0x52525cff)
const LABEL_WHITE: Color = Color(0xdfdfffff)

const CORNER_BLUE: Color = Color(0x4996feff)
const CORNER_BLUE_PORTABLE: Color = Color(0x67bbffff)
const CORNER_PINK: Color = Color(0xf898b3ff)
const CORNER_GREEN: Color = Color(0x79fe8cff)
const CORNER_GREEN_PORTABLE: Color = Color(0x2eb05aff)
const HOLIDAY_RED: Color = Color(0x904058ff)
const SATURDAY_BLUE: Color = Color(0x0d558dff)

var current_colour: Color

enum Daytimes {
	BEFORE_DAWN,	EARLY_MORNING,	MORNING,
	DAYTIME,		LUNCHTIME,		AFTERNOON,
	AFTER_SCHOOL,	EVENING,		LATE_NIGHT,
	DARK_HOUR,		UNKNOWN
}

enum WeekdayModes {
	NORMAL, SATURDAY, HOLIDAY, QUESTION_MARK
}
var weekday_mode: WeekdayModes = WeekdayModes.NORMAL
var force_holiday: bool = false

var digits_ones: Array[Texture2D]
var digits_tens: Array[Texture2D]
var digits_month_ones: Array[Texture2D]
var question_mark_digit: Texture2D
var weekday_textures: Array[Texture2D]
var current_month: int
var current_day: int


func _ready() -> void:
	current_colour = CORNER_BLUE
	moon_phase_controller.play("moon_cycle")
	
	for i in range(10):
		digits_ones.append(load("res://images/ui/date_numbers/%d.png" % i))
	
	digits_tens = digits_ones.duplicate()
	digits_tens[0] = preload("res://images/ui/date_numbers/blank_digit.png")
	
	digits_month_ones = digits_ones.duplicate()
	digits_month_ones[1] = \
		preload("res://images/ui/date_numbers/1_but_for_january_or_november's_second_digit.png")
	
	question_mark_digit = preload("res://images/ui/date_numbers/question_mark.png")
	
	for s: String in ["M", "Tu", "W", "Th", "F", "Sa", "Su", "question_mark_weekday"]:
		weekday_textures.append(load("res://images/ui/date_numbers/%s.png" % s))

# =================== NAME AND DIALOGUE ====================== #

func set_name_text(text: String) -> void:
	name_label.text = text


func set_dialogue_text(text: String) -> void:
	dialogue_label.text = text


func toggle_arrow(toggled_on: bool) -> void:
	arrow.visible = toggled_on


func toggle_choice_textbox(toggled_on: bool) -> void:
	choice_box.visible = toggled_on
	var opacity: float
	
	if toggled_on:
		name_label.label_settings.font_color = LABEL_GREY
		opacity = 0.5
	else:
		name_label.label_settings.font_color = LABEL_RED
		opacity = 1
		
	name_label.modulate.a = opacity
	dialogue_label.modulate.a = opacity


func select_choice(choice_i: int) -> void:
	for choice: Label in choices:
		choice.label_settings.font_color = LABEL_GREY
	
	choices[choice_i].label_settings.font_color = LABEL_WHITE
	
	selected_choice_bg.position.y = choices[choice_i].position.y - 4


func toggle_third_choice(toggled_on: bool) -> void:
	if toggled_on:
		choice_label_1.position.y = 35
		choice_label_2.position.y = 59
		choice_label_3.show()
	else:
		choice_label_1.position.y = 40
		choice_label_2.position.y = 77
		choice_label_3.hide()


func toggle_quotes(toggled_on: bool) -> void:
	using_quotes_for_answers = toggled_on
	for i: int in [0, 1, 2]:
		set_choice_text(i, choice_texts[i])


func set_choice_text(choice_i: int, text: String) -> void:
	choice_texts[choice_i] = text
	if using_quotes_for_answers:
		choices[choice_i].text = "”" + text + "”"
	else:
		choices[choice_i].text = text

# =================== TIME SELECTION ====================== #

func set_daytime(index: int) -> void:
	var daytime: Daytimes = Daytimes.values()[index]
	
	daytime_sprite.frame = daytime
	
	if daytime == Daytimes.DARK_HOUR:
		change_corner_colour(CORNER_GREEN)
	else:
		change_corner_colour(current_colour)


func set_month(month: int) -> void:
	current_month = month
	
	var digit1: int = month / 10
	var digit2: int = month % 10
	
	month_tens.texture = digits_tens[digit1]
	month_ones.texture = digits_month_ones[digit2]


func set_day(day: int) -> void:
	current_day = day
	
	var digit1: int = day / 10
	var digit2: int = day % 10
	
	day_tens.texture = digits_tens[digit1]
	day_ones.texture = digits_ones[digit2]


func set_weekday(index: int) -> void:
	if index > -1:
		weekday.texture = weekday_textures[index]
	
	if weekday.texture == weekday_textures[7]: # question mark
		weekday_mode = WeekdayModes.QUESTION_MARK
		month_tens.hide()
		day_tens.hide()
		
		month_ones.texture = question_mark_digit
		day_ones.texture = question_mark_digit
		change_weekday_colour()
	else:
		if weekday_mode == WeekdayModes.QUESTION_MARK:
			month_tens.show()
			day_tens.show()
			
			set_month(current_month)
			set_day(current_day)
		
		# sundays and holidays
		if weekday.texture == weekday_textures[6] or force_holiday:
			weekday_mode = WeekdayModes.HOLIDAY
		elif weekday.texture == weekday_textures[5]: # saturday
			weekday_mode = WeekdayModes.SATURDAY
		else:
			weekday_mode = WeekdayModes.NORMAL
		
		change_weekday_colour()


func set_holiday(value: bool) -> void:
	force_holiday = value
	set_weekday(-1)


func set_moon_phase(days_until_full: int) -> void:
	var digit1: int = days_until_full / 10
	var digit2: int = days_until_full % 10
	
	# instead of just using an empty texture like before, i manually hide
	# the number, because this will make the offset between "Next:" and 
	# the digit one pixel less, which ends up more accurate to the game
	next_tens.visible = digit1 > 0
	next_tens.texture = digits_ones[digit1]
	next_ones.texture = digits_ones[digit2]
	
	moon_phase_controller.seek(30 - days_until_full, true)

# =================== COLOUR SELECTION ====================== #

func choose_colour(index: int) -> void:
	match index:
		0: current_colour = CORNER_BLUE
		1: current_colour = CORNER_BLUE_PORTABLE
		2: current_colour = CORNER_PINK
		3: current_colour = CORNER_GREEN
		4: current_colour = CORNER_GREEN_PORTABLE
	
	change_corner_colour(current_colour)


func set_custom_colour(colour: Color) -> void:
	current_colour = Color(colour)
	change_corner_colour(current_colour)


func change_corner_colour(colour: Color) -> void:
	corner.modulate = colour
	
	var digit_colour: Color
	
	if weekday_mode == WeekdayModes.QUESTION_MARK:
		digit_colour = Color.from_hsv(colour.h, colour.s * 0.666667, colour.v * 0.333333)
	else:
		digit_colour = Color.from_hsv(colour.h, colour.s, colour.v * 0.2)
	
	change_weekday_colour()
		
	for digit: TextureRect in [month_tens, month_ones, day_tens, day_ones]:
		digit.modulate = digit_colour
		
	slash.modulate = Color.from_hsv(colour.h, colour.s * 0.666667, colour.v * 0.25)
	dot.modulate = Color.from_hsv(colour.h, colour.s * 0.7, colour.v * 0.333333)
	
	next_tens.modulate = colour
	next_ones.modulate = colour


func change_weekday_colour() -> void:
	var weekday_colour: Color
	var colour: Color = corner.modulate
	
	match weekday_mode:
		WeekdayModes.NORMAL:
			weekday_colour = Color.from_hsv(colour.h, colour.s * 0.333333, colour.v * 0.333333)
		WeekdayModes.SATURDAY:
			weekday_colour = Color.from_hsv(
				(SATURDAY_BLUE.h * 5 + colour.h) * 0.166667,
				SATURDAY_BLUE.s,
				SATURDAY_BLUE.v
			)
		WeekdayModes.HOLIDAY:
			weekday_colour = Color.from_hsv(
				(HOLIDAY_RED.h * 3 + colour.h) * 0.25,
				colour.s * 0.5,
				colour.v * 0.4
			)
		WeekdayModes.QUESTION_MARK:
			weekday_colour = month_tens.modulate
	
	weekday.modulate = weekday_colour
