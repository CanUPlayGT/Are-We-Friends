extends Node2D

@onready var ui := $CanvasLayer/UI
@onready var dialogue_manager := $DialogueManager

func _input(event: InputEvent) -> void:
	if event.is_action("ui_cancel"):
		get_tree().reload_current_scene()
	if event.is_action_pressed("advance"):
		if dialogue_manager.wait_for_choice and not ui.choicebox_is_opened:
			ui.show_choice()
		if not ui.text_animation_is_playing():
			dialogue_manager.advance()
		else:
			ui.stop_text_animation()
			
		
func _ready() -> void:
	#Dialogue start here...
	dialogue_manager.get_dialogue_line = $DialogueDatabase.get_dialogue_line as Callable
	dialogue_manager.advance()
