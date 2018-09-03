extends Node

const SAVE_PATH = "res://user_settings.cfg"

var config_file = ConfigFile.new()
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
	save_settings()
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