extends Control

@onready var afroza_btn: Button = $HBoxContainer/Afroza
@onready var ishmam_btn: Button = $HBoxContainer/Ishmam



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	ishmam_btn.disabled = true
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_afroza_pressed() -> void:
	print("Afroza btn")
	ishmam_btn.disabled = false

func _on_ishmam_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/Ishmam_scenes/scene001.tscn")
	print("Ishmam btn")


func _on_backbtn_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/introduction.tscn")
