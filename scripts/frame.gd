extends TextureRect

#duration in millisecond
@export var duration_ms : float = 1000
var initial_xpos : float
var is_sliding : bool = false
@export var offset : float = -50
var speed : float

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print(position.x)
	
	#convert duration to seconds
	var duration = duration_ms/1000
	speed = abs(offset) / duration

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	prints("Position.x :", position.x)
	if is_sliding: 	
		if position.x < initial_xpos:
			position.x += speed * delta

		else:
			is_sliding = false
			position.x = initial_xpos
		
func update_picture(texture2d : Texture2D) -> void:
	texture = texture2d
func slide():
	initial_xpos = position.x
	position.x += offset
	is_sliding = true
