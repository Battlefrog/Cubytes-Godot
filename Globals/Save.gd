extends Node

const SAVE_PATH = "res://user_save.json"

var last_level_completed

var directory = Directory.new()
var fileExists = directory.file_exists(SAVE_PATH)

# Default settings, also what the file looks like
var save = {
	"level_name": Level0,
	"player_deaths": 0,
	"completed_game": false,
	"used_cheats": false
}

func _ready():
	if not fileExists:
		save_game()
		load_game()
	else:
		load_game()

func save_game():
	var save_file = File.new()
	save_file.open(SAVE_PATH, File.WRITE)

func load_game():
	pass
	
func delete_save():
	directory.remove(SAVE_PATH)