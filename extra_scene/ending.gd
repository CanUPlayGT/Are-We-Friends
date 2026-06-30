extends Node2D
class_name ending_scene

@onready var rtlabel : RichTextLabel = $CanvasLayer/RichTextLabel
@onready var notifier: VisibleOnScreenNotifier2D = $CanvasLayer/RichTextLabel/VisibleOnScreenNotifier2D

signal credit_end()

var scrolling_speed := 80
# Called every frame. 'delta' is the elapsed time since the previous frame.

func _process(delta: float) -> void:
	
	rtlabel.position.y += -scrolling_speed * delta
	#print_debug(rtlabel.position.y)
	await notifier.screen_exited
	credit_end.emit()
