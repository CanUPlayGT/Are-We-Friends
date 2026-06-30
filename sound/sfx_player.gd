extends AudioStreamPlayer

var wake_up := preload("res://sound/freesound_community-sitting-on-bed-97752 (mp3cut.net).mp3")
var knock_door := preload("res://sound/soundreality-door-knocking-175163.mp3")

func _on_dialogue_manager_dialogue_changed(dialogue_line: DialogueLine) -> void:
	match dialogue_line.id:
		2, 63:
			stream = wake_up
			play()
		6, 26, 43, 67:
			stream = knock_door
			play()
