extends Node

var character_list = {
	"Rehan": preload("res://scenes/character/rehan.tscn"),
	"Hamza": preload("res://scenes/character/hamza.tscn")
}

var music_player: AudioStreamPlayer

func _ready():
	# Create and setup music player
	music_player = AudioStreamPlayer.new()
	add_child(music_player)
	
	# Load and play your music
	music_player.stream = load("res://assets/moosic/intro.mp3")  # Change path to your music
	music_player.volume_db = -10  # Adjust volume as needed
	music_player.play()
