extends Control

@export var label : Label
@export var richtextlabel : RichTextLabel
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if(Input.is_action_just_released("ui_accept")):
		next_dialogue.emit()
	
func update_texts(name, text):
	label.text = name
	richtextlabel.text = text

signal next_dialogue()

	


func _on_dialogue_manager_update_dialogue(name: String, text: String) -> void:
	update_texts(name, text)
	if name == "frame1":
		$Art/Frame1.modulate = Color.from_rgba8(255, 255, 255, 255)
		$Art/Frame2.modulate = Color.from_rgba8(255, 255, 255, 150)
	elif name == "frame2":
		$Art/Frame1.modulate = Color.from_rgba8(255, 255, 255, 150)
		$Art/Frame2.modulate = Color.from_rgba8(255, 255, 255, 255)
	
