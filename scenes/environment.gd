extends Node2D

@onready var portrait : Sprite2D = $Portrait
@onready var bg : Sprite2D = $Background

var previous_frame : int = 0

func update_portrait_from_file(file_path : String) -> void:
	portrait.texture = load(file_path) as Texture2D
	
func update_background_from_file(file_path : String) -> void:
	bg.texture = load(file_path) as Texture2D

func _on_dialogue_manager_dialogue_changed(dialogue_line: DialogueLine) -> void:
	portrait.visible = true
	var file_path : String
	match dialogue_line.frame:
		0:
			portrait.visible = false
		1:
			file_path = "res://assets/PlaceholderPals/PlaceholderPal1.png"
		2:
			file_path = "res://assets/PlaceholderPals/PlaceholderPal4.png"
	
	if previous_frame != dialogue_line.frame:
		var duration := 0.25
		var slide_xoffset := -35
		
		#slide in effect
		var tween := get_tree().create_tween()
		tween.tween_property(portrait, "position:x", portrait.position.x, duration).from(portrait.position.x + slide_xoffset)
		tween.parallel().tween_property(portrait, "modulate:a", 1, duration).from(0)
	
	previous_frame = dialogue_line.frame
	if file_path: update_portrait_from_file(file_path)
	
