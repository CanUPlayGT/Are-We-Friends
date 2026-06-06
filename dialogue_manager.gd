extends Node

var i = 0
var dialogue

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	dialogue = load_dialogue() 
	_on_dialogue_ui_next_dialogue()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func load_dialogue() :
	var json = JSON.new()
	var content
	var file = FileAccess.open("res://dialogue.json", FileAccess.READ)
	if FileAccess.get_open_error() == Error.OK:
		if Error.OK == json.parse(file.get_as_text()):
			content = json.data 
	return content

signal update_dialogue(name : String, text : String)
	
func _on_dialogue_ui_next_dialogue() -> void:
	if i >= len(dialogue):
		return
	update_dialogue.emit(dialogue[i].name, dialogue[i].text)
	i += 1
