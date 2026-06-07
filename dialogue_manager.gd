extends Node

var dialogue
var current_id = 0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	dialogue = load_dialogue_csv()
	_on_dialogue_ui_next_dialogue()
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
#returns an array of dictionaries
func load_dialogue() :
	var json = JSON.new()
	var content
	var file = FileAccess.open("res://dialogue.json", FileAccess.READ)
	if FileAccess.get_open_error() == Error.OK:
		if Error.OK == json.parse(file.get_as_text()):
			content = json.data 
	return content

#returns an array of dictionaries
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
	
	#converts an array of arrays into array of dictionaries
	var result = []
	var line = {}
	for i in content.size():
		line = {
			"id" : content[i][0],
			"name" : content[i][1],
			"text": content[i][2],
			"frame": content[i][3]
		}
		result.append(line)
		
	return result
		
signal update_dialogue(name : String, text : String)
	
func _on_dialogue_ui_next_dialogue() -> void:
	if not dialogue:
		printerr("dialogue is null")
		return

	if current_id > dialogue.size():
		return
	update_dialogue.emit(dialogue[current_id].name, dialogue[current_id].text)
	current_id += 1
	
	
