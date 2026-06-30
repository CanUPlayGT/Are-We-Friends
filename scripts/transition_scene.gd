extends TextureRect
class_name TransitionScene

@onready var rtlabel : RichTextLabel= $RichTextLabel
@onready var typewriter : Typewriter = $Typewriter

signal transition_finished()

var is_playing := false
var call_during_transition : Callable

func _ready() -> void:
	visible = false

func start() -> void:
	is_playing = true
	visible = true

	rtlabel.visible = false
	
	# fade in
	var tween := get_tree().create_tween()
	tween.tween_property(self, "modulate:a", 1, 1).from(0)
	tween.parallel().tween_property(rtlabel, "modulate:a", 1, 1).from(0)
	await tween.finished
	
	rtlabel.visible = true
	
	typewriter.start(rtlabel)
	if call_during_transition: call_during_transition.call()
	await typewriter.animation_finished

	if tween: tween.kill()
	tween = get_tree().create_tween()
	tween.tween_property(self, "modulate:a", 0, 1)
	tween.parallel().tween_property(rtlabel, "modulate:a", 0, 1)
	await tween.finished
	
	transition_finished.emit()
	visible = false
	is_playing = false
		
