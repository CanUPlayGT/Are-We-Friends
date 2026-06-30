extends Node
class_name DialogueManager

@export var current_id := 0

signal dialogue_changed(dialogue_line : DialogueLine)
	
var dialogue_line : DialogueLine 

var get_dialogue_line : Callable

var wait_for_choice : bool = false
var wait_for_transition : bool = false

func jump_to(id : int) -> void:
	current_id = id
	
func advance() -> void:
	if wait_for_choice:
		return
		
	if get_dialogue_line == null:
		print_debug("Callable get_dialogue_line is null")
		return
	
	dialogue_line = get_dialogue_line.call(current_id)
		
	#if option is not empty then wait for choice
	wait_for_choice = not dialogue_line.option_1.is_empty()
	
	dialogue_changed.emit(dialogue_line)

	if dialogue_line.transition_to == 0:
		pass
	elif dialogue_line.transition_to > 0:
		jump_to(dialogue_line.transition_to)
		wait_for_transition = true
		
	current_id += 1

func is_last() -> bool:
	if dialogue_line.transition_to < 0:
		return true
	return false
	

	
