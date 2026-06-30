extends Node
class_name DialogueDatabase

@export_file("*.json", "*.csv") var file_path : String

var dialogue_table : Array #2D Array

#Map table header to array index 
enum header{
	id,
	speaker,
	line,
	frame,
	jump_to,
	option_1,
	jump_to_1,
	option_2,
	jump_to_2,
	option_3,
	jump_to_3,
	option_4,
	jump_to_4,
	sfx,
	vfx 
}

var total_column : int = header.size()

var last_id : int = 0

func get_dialogue_line(index : int ) -> DialogueLine:
	#Convert array of data into DialogueLine object
	
	var dialogue_line := DialogueLine.new()
	var row : Array = dialogue_table[index]
	
	dialogue_line.id = row[header.id] as int
	dialogue_line.speaker = row[header.speaker] as String
	dialogue_line.line = row[header.line] as String
	dialogue_line.frame = row[header.frame] as int
	dialogue_line.transition_to = row[header.jump_to] as int
	dialogue_line.option_1 = row[header.option_1] as String
	dialogue_line.jump_to_1 = row[header.jump_to_1] as int
	dialogue_line.option_2 = row[header.option_2] as String
	dialogue_line.jump_to_2 = row[header.jump_to_2] as int
	dialogue_line.option_3 = row[header.option_3] as String
	dialogue_line.jump_to_3 = row[header.jump_to_3] as int
	dialogue_line.option_4 = row[header.option_4] as String
	dialogue_line.jump_to_4 = row[header.jump_to_4] as int
	
	return dialogue_line
	
func _ready() -> void:
	if not FileAccess.file_exists(file_path):
		printerr("File not found: %s" % file_path)
		return
	var file : FileAccess = FileAccess.open(file_path, FileAccess.READ)
	if FileAccess.get_open_error() != Error.OK:
		printerr("Error opening dialogue file")
		return
	if file_path.get_extension() == "json":
		dialogue_table = load_dialogue_json(file)
		last_id = dialogue_table.pop_back()[header.id] as int
	elif file_path.get_extension() == "csv":
		dialogue_table = load_dialogue_csv(file)
		last_id = dialogue_table.pop_back()[header.id] as int
	else:
		print_debug("Error: Wrong dialogue file format")
		
func load_dialogue_json(file : FileAccess) -> Array:
	var json := JSON.new()
	var content : Array

	if FileAccess.get_open_error() == Error.OK:
		if Error.OK == json.parse(file.get_as_text()):
			content = json.data 
	return content

func load_dialogue_csv(file : FileAccess) -> Array :
	file.get_csv_line() #discard the first line (the header in a table)
	
	#Read every line
	var content := []
	var buffer := []
	while file.get_position() < file.get_length():
		#check if a line is empty first
		buffer = file.get_csv_line()
		if buffer[0] == "":
			continue
			
		content.append(buffer) 
		
	#print(content)
		
	return content
		
