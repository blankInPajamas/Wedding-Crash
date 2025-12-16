extends Control

var isTimeout: bool = false
@onready var bgm: AudioStreamPlayer = $bgm

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	await get_tree().create_timer(0.25).timeout
	isTimeout = true
	bgm.play()

func _input(event) -> void:
	#print(event)
	if not isTimeout: return
	if (event is InputEventMouseButton and event.is_pressed()) or (event is InputEventScreenTouch and event.is_pressed()) :
		get_tree().change_scene_to_file("res://scenes/game_select.tscn")
		#print("Works")
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
