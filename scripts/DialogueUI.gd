extends Control

@export var label : Label
@export var richtextlabel : RichTextLabel
@export var character1 : Texture2D
@export var character2 : Texture2D

#Map table header to array index 
enum header{
	id,
	speaker,
	line,
	frame,
	finish,
	option1,
	jumpto1,
	option2,
	jumpto2,
	option3,
	jumpto3,
	option4,
	jumpto4,
}

var total_column = header.size()
var array = []
var buttons : Array = []
var choicebox_is_opened = false

var previous_value : String 

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
	
func _input(event : InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		get_tree().reload_current_scene()
		
	if event.is_action_pressed("advance"):
		if not choicebox_is_opened:
			advance()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
func update_texts(speaker, text):
	label.text = speaker
	richtextlabel.text = text

signal next_dialogue(jump_to : int)

func _on_dialogue_manager_update_dialogue(line : Array) -> void:
	update_texts(line[header.speaker], line[header.line])
	$Typewriter.start(richtextlabel)
	
	if line[header.frame] != previous_value:
		match line[header.frame]:
			"1":
				$Art/Frame.update_picture(character1)
			"2":
				$Art/Frame.update_picture(character2)
		$Art/Frame.slide()
	previous_value = line[header.frame]
	array = line
	
func advance() -> void:
	if $Typewriter.is_typing:
		$Typewriter.stop()
	
	if array == null :
		printerr("dialogue_ui: array value is null")
		return
	if array.size() < total_column:
		print("Wrong format")
		return
	#check if current line is the last
	if String(array[header.finish]).to_lower() == "true":
		return

	#Self-explainable
	if array[header.option1] != "":
		open_choicebox()
	else:
		#send signal to DialogueManager
		next_dialogue.emit(-1)
		
	
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
				$Options/VBoxContainer.add_child(buttons.back(), true)
func on_button_pressed(index: int):
	choicebox_is_opened = false
	#JUMPTOx column must be next to the OPTIONx column
	#hence index + 1 
	var next_id = int(array[index + 1])
	next_dialogue.emit(next_id)
	buttons.clear()
	for child in $Options/VBoxContainer.get_children():
		$Options/VBoxContainer.remove_child(child)
		child.queue_free()
