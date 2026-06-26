extends Node2D

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("advance"):
		$DialogueManager.advance()
		
func _ready() -> void:
	$DialogueManager.get_dialogue_line = $DialogueDatabase.get_dialogue_line as Callable
	$DialogueManager.advance()
