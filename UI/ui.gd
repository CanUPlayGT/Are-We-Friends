extends Control
class_name UI
var dl: DialogueLine

var choicebox_is_opened : bool = false

@onready var typewriter_player : Typewriter = $Typewriter
@onready var label : Label = $DialogueBox/Panel/VBoxContainer/MarginContainer/Label
@onready var richtextlabel : RichTextLabel = $DialogueBox/Panel/VBoxContainer/MarginContainer2/RichTextLabel
@onready var button_container := $CenterContainer/VBoxContainer

signal choice_chosen(index : int, jump_to : int)

func _on_dialogue_manager_dialogue_changed(Dialogue_line: DialogueLine) -> void:
	dl = Dialogue_line
	label.text = dl.speaker
	richtextlabel.text = dl.line
	#print(dl.line)
	
func show_choice() -> void:
	choicebox_is_opened = true
	#manually create 4 buttons to give each button an identifier
	#so that we can track which button is chosen later on
	create_choice(dl.option_1, dl.jump_to_1, 0)
	create_choice(dl.option_2, dl.jump_to_2, 1)
	create_choice(dl.option_3, dl.jump_to_3, 2)
	create_choice(dl.option_4, dl.jump_to_4, 3)
	
## dynamically create choice button if text is not empty
func create_choice(text : String, jump_to : int, index : int) -> void:
	if text != "":
		var button : Button = Button.new()
		button.text = text
		button.custom_minimum_size.x = 400
		button.custom_minimum_size.y = 40
		button.pressed.connect(on_button_pressed.bind(index, jump_to))
		button_container.add_child(button)

func on_button_pressed(index : int, jump_to: int) -> void:
	choice_chosen.emit(index, jump_to)
	choicebox_is_opened = false
	for child in button_container.get_children():
		button_container.remove_child(child)

func text_animation_is_playing() -> bool :
	return typewriter_player.is_playing()

func stop_text_animation() -> void:
	typewriter_player.stop()
	return 
	
func update_ui(text : String) -> void:
	richtextlabel.text = text
	
func set_visible_characters(visible_characters : int) -> void:
	#print("fired")
	richtextlabel.visible_characters = visible_characters

func start_text_animation() -> void:
	typewriter_player.start(richtextlabel)
	
