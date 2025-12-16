extends Control

@onready var ui_box: CanvasLayer = $CanvasLayer/UIBox
@onready var character_container: Node2D = $CanvasLayer/CharacterContainer

var content_location: String = "res://content/Ishmam/scene01.txt"
var current_character = null

func _ready() -> void:
	ui_box.speaker_changed.connect(_on_speaker_changed)
	ui_box.open_file(content_location)
	ui_box.start_scene("Starting scene")
	
	await get_tree().process_frame  
	if ui_box.speaker_name.text != "":
		_on_speaker_changed(ui_box.speaker_name.text)


func _on_speaker_changed(speaker_name: String) -> void:
	# Remove old character
	if current_character:
		current_character.queue_free()
		current_character = null
	
	# Load new character from Global
	if Global.character_list.has(speaker_name):
		var character_scene = Global.character_list[speaker_name].instantiate()
		character_container.add_child(character_scene)
		current_character = character_scene
	else:
		print("Character not found in character_list: ", speaker_name)


func _process(delta: float) -> void:
	pass
