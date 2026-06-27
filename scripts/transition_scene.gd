extends TextureRect
class_name TransitionScene

@onready var rtlabel := $RichTextLabel
@onready var typewriter := $Typewriter

signal transition_finished()

var is_playing = false
var call_during_transition : Callable
func _ready() -> void:
	visible = false

func start() -> void:
	is_playing = true
	visible = true
	modulate.a = 0
	rtlabel.modulate.a = 0
	rtlabel.visible = false
	var tween := get_tree().create_tween()
	
	tween.tween_property(self, "modulate:a", 1, 1)
	tween.parallel().tween_property(rtlabel, "modulate:a", 1, 1)
	await tween.finished
	
	rtlabel.visible = true
	typewriter.start(rtlabel)
	call_during_transition.call()
	await typewriter.animation_finished

	if tween: tween.kill()
	tween = get_tree().create_tween()
	tween.tween_property(self, "modulate:a", 0, 1)
	tween.parallel().tween_property(rtlabel, "modulate:a", 0, 1)
	await tween.finished
	transition_finished.emit()
	visible = false
	is_playing = false
		
