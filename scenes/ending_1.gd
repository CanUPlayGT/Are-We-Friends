extends Node2D

@onready var rtlabel : RichTextLabel = $CanvasLayer/RichTextLabel

var scrolling_speed := 80
# Called every frame. 'delta' is the elapsed time since the previous frame.

func _process(delta: float) -> void:
	
	rtlabel.position.y += -scrolling_speed * delta
	#print_debug(rtlabel.position.y)
