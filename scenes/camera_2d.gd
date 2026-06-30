extends Camera2D
class_name CameraShake

var is_shaking : bool 
var elapsed_time : float = 0
var duration : float = 1
var move_speed : float = 10
var scale_multiplier : float = 20

func shake() -> void:
	is_shaking = true
	
func stop_shaking() -> void:
	is_shaking = false
	
func _process(delta: float) -> void:
	if is_shaking:
		elapsed_time += delta 
		if elapsed_time <= duration:
			offset.x = sin(elapsed_time * move_speed) * scale_multiplier
		else:
			elapsed_time -= duration
			is_shaking = false
	else:
		offset.x = lerp(offset.x, 0.0, delta * move_speed)
			

func _on_dialogue_manager_dialogue_changed(dialogue_line: DialogueLine) -> void:
	match dialogue_line.id:
		2, 67:
			shake()
		_:
			if is_shaking:
				stop_shaking()
