extends Node

var dialogue
@export var current_id = 0

func _ready() -> void:
	dialogue = load_dialogue_csv()
	_on_dialogue_ui_next_dialogue(-1)
	
func load_dialogue() :
	var json = JSON.new()
	var content
	var file = FileAccess.open("res://dialogue.json", FileAccess.READ)
	if FileAccess.get_open_error() == Error.OK:
		if Error.OK == json.parse(file.get_as_text()):
			content = json.data 
	return content

func load_dialogue_csv() :
	var file_path = "res://dialogue.csv"
	if not FileAccess.file_exists(file_path):
		printerr("File not found: %s" % file_path)
		
	var file = FileAccess.open("res://dialogue.csv", FileAccess.READ)
	if file == null:
		return null
		
	file.get_csv_line() #discard the first line (header)
	
	#Read every line
	var content = []
	var temp = []
	while file.get_position() < file.get_length():
		#check if a line is empty first
		temp = file.get_csv_line()
		if temp[0] == "":
			return;
			
		content.append(temp) 
		
	#print(content)
		
	return content
		
signal update_dialogue(line : Array)
	
func _on_dialogue_ui_next_dialogue(jump_to : int = -1) -> void:
	if not dialogue:
		printerr("dialogue is null")
		return

	if not current_id < dialogue.size():
		return
	
	if jump_to > -1:
		current_id = jump_to
		
	update_dialogue.emit(dialogue[current_id])
	current_id += 1

	

	
	
