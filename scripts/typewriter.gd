extends Node
class_name Typewriter
#character per second
@export var cps : float = 8


var label: RichTextLabel 
var appear_delay: float 
var is_typing : bool = false
var elapsed_time : float
var count : float 

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	appear_delay = 1/cps
	#var parent = get_parent()
	#if parent is not RichTextLabel:
		#printerr("typewriter must be a child of RichText Label")
	#else: 
		#label = parent

func start(rich_text_label : RichTextLabel) -> void:
		label = rich_text_label
		label.visible_characters = 0
		is_typing = true
		elapsed_time = 0
func stop() -> void:
		label.visible_characters = -1
		is_typing = false

func _process(delta: float) -> void:
	if is_typing:
		elapsed_time += delta
		#prints(elapsed_time, appear_delay)
		while elapsed_time >= appear_delay:
			label.visible_characters += 1
			elapsed_time -= appear_delay
		if label.get_total_character_count() == label.visible_characters:
			is_typing = false
			elapsed_time = 0
