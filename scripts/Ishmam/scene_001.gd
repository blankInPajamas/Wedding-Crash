extends Control

@onready var ui_box: CanvasLayer = $CanvasLayer/UIBox
var content_location: String = "res://content/Ishmam/scene01.txt"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	ui_box.open_file(content_location)
	ui_box.start_scene("Starting scene")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
