extends Node

const SAVE_PATH = "res://user_settings.cfg"

var directory = Directory.new()
var fileExists = directory.file_exists(SAVE_PATH)
var config_file = ConfigFile.new()

# Default settings, also what the file looks like
var settings = {
	"audio": {
		"master_volume": 0.0,
		"music_volume": 0.0,
		"sfx_volume": 0.0
	},
	"window": {
		"fullscreen": false,
		"v-sync": false,
		"resolution": Vector2(1336,768)
	}
}

func _ready():
	if not fileExists:
		save_settings()
		load_settings()
	else:
		load_settings()

func save_settings():
	for section in settings.keys():
		for key in settings[section]:
			config_file.set_value(section, key, settings[section][key])
	
	config_file.save(SAVE_PATH)

func load_settings():
	# Open the file
	var err = config_file.load(SAVE_PATH)
	if err != OK:
		printerr("Failed loading settings! Error code: " + err)
		return null
	
	for section in settings.keys():
		for key in settings[section]:
			settings[section][key] = config_file.set_value(section, key, null)

func get_config_file():
	return config_file

func get_config_file_path():
	return SAVE_PATH