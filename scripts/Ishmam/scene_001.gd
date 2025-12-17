extends Control

@onready var ui_box: CanvasLayer = $CanvasLayer/UIBox
@onready var character_container: Node2D = $CanvasLayer/CharacterContainer
@onready var scene_intro: Control = $Scene_intro
@onready var scene_heading: Label = $Scene_intro/PanelContainer/Label

var content_location: String = Global.scene_list[Global.scene_list_count]
var current_character = null

func _ready() -> void:
	# Make the scene_intro stay for 2 seconds and then make it invisible and allow the process to run as it is
	# Set heading text (from Global, which you already fill via ###)
	#scene_heading.text = Global.scene_heading
	#scene_intro.visible = true
#
	## Pause dialogue input
	#ui_box.set_process_input(false)
#
	## Show intro for 2 seconds
	#await get_tree().create_timer(2.0).timeout
#
	#scene_intro.visible = false

	# Resume dialogue input
	ui_box.set_process_input(true)
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
