extends CanvasLayer

@onready var dialogue: RichTextLabel = $DialogBox/Dialogue_label
@onready var speaker_name: Label = $SpeakerBox/Control/Speaker_name

var file_location: String = ""
var dialogue_arr: Array

func _set_dialogue_values(speaker: String, dialogue_list: Array) -> void:
	dialogue_arr = dialogue_list
	speaker_name.text = speaker

func open_file(location: String) -> void:
	var file = FileAccess.open(location, FileAccess.READ)
	
	var scenes: Dictionary = {}
	var current_speaker: String = ""
	var current_scene := ""
	
	while not file.eof_reached():
		var line := file.get_as_text().strip_edges()
		
		if line == "": continue
		
		if line.begins_with('[') and line.ends_with(']'): 
			var name = line.substr(1,line.length()-2)
			current_speaker = name
			print(current_speaker)
			continue
		
		
		
	file.close()
	#print(content)
	

func _ready() -> void:
	#print(dialogue_arr)
	#print(speaker_name.text)
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
