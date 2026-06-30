extends Node2D

@onready var ui : UI = $CanvasLayer/UI
@onready var dialogue_manager : DialogueManager = $DialogueManager
@onready var database : DialogueDatabase = $DialogueDatabase
@onready var transition : TransitionScene = $CanvasLayer/TransitionScene
@onready var camera : CameraShake = $CameraShake
@onready var sfx_player : AudioStreamPlayer = $SfxPlayer
@onready var bgm : AudioStreamPlayer = $BGM

var ending_1 := preload("res://extra_scene/ending_1.tscn")
var ending_2 := preload ("res://extra_scene/ending_2.tscn")

var flag : Array[bool]
var ending_is_playing : bool

func _input(event: InputEvent) -> void:
	if event.is_action("ui_cancel"):
		get_tree().reload_current_scene()
	if event.is_action_pressed("advance"):
		if dialogue_manager.is_last() and not ending_is_playing:
			ending_is_playing = true
			bgm.playing = false
			var instance : ending_scene
			#menentukan ending
			#player akan mendapat ending 2 jika selalu memilih opsi 2
			#i.e sebanyak 3 kali
			if flag.count(2) == 3:
				instance = ending_2.instantiate()
			else:
				#dapat ending 1, jika setidaknya memilih opsi 1 sekali
				instance = ending_1.instantiate()
				
			add_child(instance)
			#animasi fade in
			var tween := get_tree().create_tween()
			tween.tween_property(instance, "modulate:a", 1, 0.5).from(0)
			tween.parallel().tween_property(ui, "modulate:a", 0, 0.5).from(1)
			await instance.credit_end
			get_tree().reload_current_scene()
			
			
		#print_debug("wait_for_transition: %s" % dialogue_manager.wait_for_transition)
		if dialogue_manager.current_id <= database.last_id:	
			if camera.is_shaking:
				camera.stop_shaking()
			if sfx_player.playing:
				sfx_player.playing = false
			if dialogue_manager.wait_for_transition:
				if not transition.is_playing:
					start_transition()
			elif dialogue_manager.wait_for_choice :
				if not ui.choicebox_is_opened:
					ui.show_choice()
			elif not ui.text_animation_is_playing():
				if not dialogue_manager.is_last():
					dialogue_manager.advance()
					ui.start_text_animation()
				else:
					bgm.playing = false
			else:
				ui.stop_text_animation()
			
func _ready() -> void:
	#Dialogue start here...
	dialogue_manager.get_dialogue_line = database.get_dialogue_line as Callable
	dialogue_manager.advance()
	ui.start_text_animation()

func start_transition() -> void:
	transition.start()
	
	#call advance() during transition but start animation
	#after the transition ends
	var callable : Callable = func() -> void:
		dialogue_manager.advance()
		ui.set_visible_characters(0)
		
	transition.call_during_transition = callable
	
	await transition.transition_finished
	
	ui.start_text_animation()
	
	dialogue_manager.wait_for_transition = false

func _on_ui_choice_chosen(index : int, jump_to: int) -> void:
	#keep a log of which buttons the player chose
	flag.append(index)
	
	ui.stop_text_animation()
	dialogue_manager.jump_to(jump_to)
	dialogue_manager.wait_for_choice = false
	dialogue_manager.advance()
	ui.start_text_animation()
