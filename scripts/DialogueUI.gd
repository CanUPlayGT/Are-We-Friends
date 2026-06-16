extends Control

@export var label : Label
@export var richtextlabel : RichTextLabel

#Map table header to array index 
enum header{
	id,
	name,
	line,
	frame,
	has_options,
	option1,
	jumpto1,
	option2,
	jumpto2,
	option3,
	jumpto3,
	option4,
	jumpto4,
	end_of_line
}

var array = []
var buttons : Array = []
var choicebox_is_opened = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$ItemList.visible = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().reload_current_scene()
	if Input.is_action_just_released("ui_accept") and not choicebox_is_opened:
		if array == null :
			printerr("dialogue_ui: array value is null")
			return
		if array.size() < 13:
			print("Wrong format")
			return
		if String(array[header.end_of_line]).to_lower() == "true":
			return
		if array[header.has_options] != "":
			open_choicebox()
			#$ItemList.visible = true
			#$ItemList.clear()
			#for i in [header.option1, header.option2,
						#header.option3, header.option4] :
					#if not array[i] == "":
						#$ItemList.add_item(array[i])
		else:
			next_dialogue.emit(-1)
	
func update_texts(speaker, text):
	label.text = speaker
	richtextlabel.text = text

signal next_dialogue(jump_to : int)

func _on_dialogue_manager_update_dialogue(line : Array) -> void:
	update_texts(line[header.name], line[header.line])
	if line[header.frame] == "1":
		$Art/Frame1.modulate = Color.from_rgba8(255, 255, 255, 255)
		$Art/Frame2.modulate = Color.from_rgba8(255, 255, 255, 150)
	elif line[header.frame]== "2":
		$Art/Frame1.modulate = Color.from_rgba8(255, 255, 255, 150)
		$Art/Frame2.modulate = Color.from_rgba8(255, 255, 255, 255)
	array = line

func open_choicebox():
	choicebox_is_opened = true
	for i in [header.option1, header.option2, 
			header.option3, header.option4]:
			if array[i] != "":
				var button = Button.new()
				button.text = array[i]
				button.custom_minimum_size.x = 400
				button.custom_minimum_size.y = 40
				button.pressed.connect(on_button_pressed.bind(i))
				buttons.append(button)
				$CenterContainer/VBoxContainer.add_child(buttons.back(), true)
func on_button_pressed(index: int):
	choicebox_is_opened = false
	var next_id = int(array[index + 1])
	next_dialogue.emit(next_id)
	buttons.clear()
	for child in $CenterContainer/VBoxContainer.get_children():
		$CenterContainer/VBoxContainer.remove_child(child)
		child.queue_free()
func _on_item_list_item_selected(index: int) -> void:
	var jump_to
	match index:
		0: jump_to = array[header.jumpto1]
		1: jump_to = array[header.jumpto2]
		2: jump_to = array[header.jumpto3]
		3: jump_to = array[header.jumpto4]
		_:
			print("invalid value on 'jump_to'")
	print(jump_to)
	next_dialogue.emit(int(jump_to))
	$ItemList.visible = false
