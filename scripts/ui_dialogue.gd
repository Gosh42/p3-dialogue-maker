extends Node

var dialogue: DialogueController

@onready var dialogue_edit: TextEdit = %DialogueEdit

@onready var answer_settings: VBoxContainer = %AnswerSettings
@onready var choice_spin_box: SpinBox = %ChoiceSpinBox
@onready var quotes_check: CheckButton = %QuotesCheck
@onready var choice_3_edit: LineEdit = %Choice3Edit

@onready var navi_settings: VBoxContainer = %NaviSettings
@onready var navi_select: OptionButton = %NaviSelection
@onready var navi_dialogue_edit: TextEdit = %NaviDialogueEdit
@onready var custom_navi_hbox: HBoxContainer = %CustomNavi
@onready var navi_path_edit: LineEdit = %NaviPathEdit
@onready var file_dialog: FileDialog = %FileDialogNavi
var navigators: Array[Texture]
var custom_navi: Texture

# =================== INITIAL SETUP ====================== #

func _ready() -> void:
	var screen: ScreenControlGetter = %Screen
	
	var navi_names: Array[String] = ["Fuuka", "Mitsuru", \
		"Yukari", "Junpei", "Akihiko", "Aigis", "Koromaru", \
		"Ken", "Shinjiro", "Metis", "Aigis (unused placeholder)"]
	
	for navi: String in navi_names:
		navigators.append(load("res://images/ui/navigator/" + navi + ".png"))
		navi_select.add_item(navi)
	
	navi_select.add_item("Custom")
	
	dialogue = screen.get_dialogue_controller()
	
	dialogue.toggle_choice_textbox(false)
	dialogue.toggle_third_choice(false)
	dialogue.select_choice(0)
	dialogue.toggle_quotes(true)
	dialogue.toggle_navi_textbox(false)
	dialogue.set_navi(navigators[0])
	
	file_dialog.current_path = OS.get_system_dir(OS.SYSTEM_DIR_PICTURES) + "/"

# ====================== DIALOGUE BOX ====================== #

func _on_name_changed(new_text: String) -> void:
	dialogue.set_name_text(new_text)


func _on_dialogue_changed() -> void:
	dialogue.set_dialogue_text(dialogue_edit.text)


func _on_arrow_toggled(toggled_on: bool) -> void:
	dialogue.toggle_arrow(toggled_on)

# ====================== ANSWER BOX ====================== #

func _on_answer_toggled(toggled_on: bool) -> void:
	answer_settings.visible = toggled_on
	dialogue.toggle_choice_textbox(toggled_on)


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
	
	dialogue.toggle_third_choice(toggled_on)
	dialogue.select_choice(selection - 1)


func _on_selected_choice_changed(value: float) -> void:
	if value > choice_spin_box.max_value:
		choice_spin_box.value = choice_spin_box.min_value
	elif value < choice_spin_box.min_value:
		choice_spin_box.value = choice_spin_box.max_value
	else:
		dialogue.select_choice(int(value) - 1)


func _on_quotes_toggled(toggled_on: bool) -> void:
	dialogue.toggle_quotes(toggled_on)


func _on_choice_1_text_changed(new_text: String) -> void:
	dialogue.set_choice_text(0, new_text)


func _on_choice_2_text_changed(new_text: String) -> void:
	dialogue.set_choice_text(1, new_text)


func _on_choice_3_text_changed(new_text: String) -> void:
	dialogue.set_choice_text(2, new_text)

# ====================== NAVIGATOR BOX ====================== #

func _on_navigator_toggled(toggled_on: bool) -> void:
	navi_settings.visible = toggled_on
	dialogue.toggle_navi_textbox(toggled_on)


func _on_navigator_selected(index: int) -> void:
	var is_custom: bool = index >= len(navigators)
	
	custom_navi_hbox.visible = is_custom
	
	if not is_custom:
		dialogue.set_navi(navigators[index])


func _on_navigator_dialogue_changed() -> void:
	dialogue.set_navi_text(navi_dialogue_edit.text)


func _on_navi_file_open_pressed() -> void:
	file_dialog.popup()


func _on_file_dialog_navi_file_selected(path: String) -> void:
	var img: Image = Image.new()
	var error: Error = img.load(path)
	
	if error != Error.OK:
		navi_path_edit.text = "Error loading the image."
		custom_navi = null
		return
	
	navi_path_edit.text = path
	
	custom_navi = ImageTexture.create_from_image(img)
	dialogue.set_navi(custom_navi)
