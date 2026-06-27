extends Node
class_name Typewriter

#character per second
@export var cps : float = 8
@export var period_delay_ms : float = 0.5
@export var comma_delay_ms : float = 0.25

var label: RichTextLabel 

enum state{
	playing,
	paused,
	idle
}

signal animation_finished()
signal animation_started()

var current_state : state

var current_character_index : int

var appear_delay: float 
var elapsed_time : float

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	appear_delay = 1/cps
	current_state = state.idle

func is_playing() -> bool:
	return true if current_state == state.playing else false
	
func start(rich_text_label : RichTextLabel) -> void:
	label = rich_text_label
		
	current_character_index = -1
	label.visible_characters = 0
	current_state = state.playing
	elapsed_time = 0
	animation_started.emit()
		
func stop() -> void:
	label.visible_characters = -1
	current_state = state.idle
	animation_finished.emit()
	
func pause() -> void:
	current_state = state.paused
func unpause() -> void:
	current_state = state.playing
	
func _process(delta: float) -> void:
	if current_state == state.playing:
		elapsed_time += delta
	
		#prints(elapsed_time, appear_delay)
		while elapsed_time >= appear_delay:
			
			label.visible_characters += 1
			current_character_index += 1
			
			if label.get_total_character_count() == label.visible_characters:
				
				stop()
				return
			
			#print(label.get_total_character_count())
			#print_debug(label.text[current_character_index])
			#print_debug("current character index: %s, visible characters: %s " 
					#% [current_character_index, label.visible_characters])
			
			elapsed_time -= appear_delay
			
			
			match label.text[current_character_index]:
				",":
					elapsed_time -= comma_delay_ms
				".", "?":
					var next_character_index = current_character_index + 1
					var last_character_index = label.text.length() - 1
					if next_character_index > last_character_index:
						return
					match label.text[next_character_index]:
						null :
							break
						'"', "(", ")", "?":
							return
							
					elapsed_time -= period_delay_ms
				"\n":
					elapsed_time -= period_delay_ms
				"?":
					elapsed_time -= period_delay_ms
					
