extends CanvasLayer

@onready var dialogue: RichTextLabel = $DialogueArea/DialogBox/Dialogue_label
@onready var speaker_name: Label = $DialogueArea/SpeakerBox/Control/Speaker_name
@onready var dialogue_area: Control = $DialogueArea
@onready var choice_area: Control = $ChoiceArea

@onready var choice_question: Label = $ChoiceArea/PanelContainer/VBoxContainer/Question

@onready var choice_01: Button = $ChoiceArea/PanelContainer/VBoxContainer/HBoxContainer/Choice01
@onready var choice_02: Button = $ChoiceArea/PanelContainer/VBoxContainer/HBoxContainer/Choice02

var scenes: Dictionary = {}
var current_scene: String = ""
var current_index: int = 0
var current_question : String = ""

var is_typing := false
var typing_speed := 0.03

var choice_question_label : String = ""
var choice_options: Array = []

func _start_typewriter() -> void:
	is_typing = true
	dialogue.visible_characters = 0

	var total_chars := dialogue.get_total_character_count()

	for i in range(total_chars):
		dialogue.visible_characters += 1
		await get_tree().create_timer(typing_speed).timeout

	is_typing = false

func open_file(path: String) -> void:
	var file := FileAccess.open(path, FileAccess.READ)
	if file == null:
		push_error("Failed to open file: " + path)
		return

	scenes.clear()

	var current_speaker := ""
	var scene_name := ""

	while not file.eof_reached():
		var line := file.get_line().strip_edges()
		if line.is_empty():
			continue

		# Scene marker
		if line.begins_with("#"):
			scene_name = line.substr(1).strip_edges()

			if not scenes.has(scene_name):
				scenes[scene_name] = []

			continue

		# Speaker marker
		if line.begins_with("[") and line.ends_with("]"):
			current_speaker = line.substr(1, line.length() - 2)
			continue

		if line.begins_with("?") and line.ends_with("?"):
			choice_question_label = line.substr(2, line.length()-2)
			print(choice_question_label)
			continue
			#_change_scene_to_choice_area()

		if line.begins_with(">"):
			var parts := line.replace("> ","").split("|")
			choice_options.append(
				{
					"text": parts[0].strip_edges(),
					"target": parts[1].strip_edges()
				}
			)
			continue
			
		#if line == "== end ==":
			#return
		
		# Dialogue line
		if scene_name != "" and current_speaker != "":
			scenes[scene_name].append({
				"speaker": current_speaker,
				"text": line
			})


	file.close()
	
	#for scene in scenes.keys():
		#print(scene, " → ", scenes[scene_name])

	#print("Loaded scenes:", scenes.keys())

func _change_scene_to_choice_area() -> void:
	choice_area.visible = true
	dialogue_area.visible = false

	# Safety first
	choice_01.visible = false
	choice_02.visible = false

	if choice_options.size() > 0:
		choice_01.text = choice_options[0]["text"]
		choice_01.visible = true

	if choice_options.size() > 1:
		choice_02.text = choice_options[1]["text"]
		choice_02.visible = true
		
func start_scene(scene_name: String) -> void:
	if not scenes.has(scene_name):
		push_error("Scene not found: " + scene_name)
		return

	if scenes[scene_name].is_empty():
		push_warning("Scene is empty: " + scene_name)
		return

	current_scene = scene_name
	current_index = 0
	_show_current_line()

func next_line() -> void:
	if current_scene == "":
		return

	current_index += 1

	if current_index >= scenes[current_scene].size():
		_end_scene()
		return

	await get_tree().create_timer(1).timeout
	_show_current_line()

func _show_current_line() -> void:
	if not scenes.has(current_scene):
		return

	var scene_data: Array = scenes[current_scene]

	if current_index < 0 or current_index >= scene_data.size():
		return

	var entry: Dictionary = scene_data[current_index]
	speaker_name.text = entry.get("speaker", "")
	dialogue.text = entry.get("text", "")
	
	_start_typewriter()

func _end_scene() -> void:
	if choice_question_label != "":
		current_question = choice_question_label
		_change_scene_to_choice_area()
		choice_question.text = current_question
		return

	_reset_scene()
	
func _reset_scene() -> void:
	print("Scene finished:", current_scene)
	speaker_name.text = ""
	dialogue.text = ""
	current_scene = ""
	current_index = 0
	choice_question_label = ""
	choice_options.clear()
	

func _input(event: InputEvent) -> void:
	if choice_area.visible:
		return
	
	if current_scene == "":
		return

	if not event.is_pressed() or event.is_echo():
		return
		
	if event is InputEventMouseButton or event is InputEventScreenTouch or event.is_action_pressed("ui_accept"):
		if is_typing:
			dialogue.visible_characters = dialogue.get_total_character_count()
			is_typing = false
		else:
			next_line()
			
func _on_choice_btn_pressed(val: int) -> void:
	if val < 0 or val >= choice_options.size():
		return

	var target_scene: String = choice_options[val]["target"]

	# Hide choice UI
	choice_area.visible = false
	dialogue_area.visible = true

	# Clear choice state
	choice_question_label = ""
	choice_options.clear()
	current_question = ""

	# Jump to next logical scene
	start_scene(target_scene)
	
	#var heading_scene: String = 

func _ready() -> void:
	choice_area.visible = false
	
	choice_01.pressed.connect(Callable(self, "_on_choice_btn_pressed").bind(0))
	choice_02.pressed.connect(Callable(self, "_on_choice_btn_pressed").bind(1))
