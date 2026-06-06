extends Control

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if(Input.is_action_just_released("ui_accept")):
		next_dialogue.emit()
	
func update_texts(name, text):
	$MarginContainer/DialoguePanel/MarginContainer/Label.text = name
	$MarginContainer/DialoguePanel/MarginContainer/MarginContainer/RichTextLabel.text = text



signal next_dialogue()

	


func _on_dialogue_manager_update_dialogue(name: String, text: String) -> void:
	update_texts(name, text)
	if name == "Hoshino":
		$Char/Hoshino.modulate = Color.from_rgba8(255, 255, 255, 255)
		$Char/Momoi.modulate = Color.from_rgba8(255, 255, 255, 150)
	elif name == "Momoi":
		$Char/Hoshino.modulate = Color.from_rgba8(255, 255, 255, 150)
		$Char/Momoi.modulate = Color.from_rgba8(255, 255, 255, 255)
	
