extends Node2D

@onready var portrait := $Portrait
@onready var bg := $Background

func update_portrait_from_file(file_path : String) -> void:
	portrait.texture = load(file_path) as Texture2D
	
func update_background_from_file(file_path : String) -> void:
	bg.texture = load(file_path) as Texture2D


func _on_dialogue_manager_dialogue_changed(dialogue_line: DialogueLine) -> void:
	var file_path : String
	match dialogue_line.frame:
		1:
			file_path = "res://assets/PlaceholderPals/PlaceholderPal1.png"
		2:
			file_path = "res://assets/PlaceholderPals/PlaceholderPal14.png"
	
	if file_path: update_portrait_from_file(file_path)
