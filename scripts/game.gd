extends Node2D

@onready var ui := $CanvasLayer/UI
@onready var dialogue_manager := $DialogueManager
@onready var database := $DialogueDatabase
@onready var transition := $CanvasLayer/TransitionScene

func _input(event: InputEvent) -> void:
	if event.is_action("ui_cancel"):
		get_tree().reload_current_scene()
	if event.is_action_pressed("advance"):
		#print_debug("wait_for_transition: %s" % dialogue_manager.wait_for_transition)
		if dialogue_manager.current_id <= database.last_id:	

			if dialogue_manager.wait_for_transition:
				if not transition.is_playing:
					start_transition()
			elif dialogue_manager.wait_for_choice :
				if not ui.choicebox_is_opened:
					ui.show_choice()
			elif not ui.text_animation_is_playing():
				if not dialogue_manager.is_last():
					dialogue_manager.advance()
					ui.start_animation()
			else:
				ui.stop_text_animation()

func _ready() -> void:
	#Dialogue start here...
	dialogue_manager.get_dialogue_line = $DialogueDatabase.get_dialogue_line as Callable
	dialogue_manager.advance()
	ui.start_animation()

func start_transition():
	transition.start()
	
	var callable = func():
		dialogue_manager.advance()
		ui.set_visible_characters(0)
		
	transition.call_during_transition = callable
	
	await transition.transition_finished
	
	ui.start_animation()
	
	dialogue_manager.wait_for_transition = false

func _on_ui_choice_chosen(jump_to: int) -> void:
	ui.stop_text_animation()
	dialogue_manager.jump_to(jump_to)
	dialogue_manager.wait_for_choice = false
	dialogue_manager.advance()
