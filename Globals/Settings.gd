extends Node

const SAVE_PATH = "res://user_settings.cfg"

var dir = Directory.new()
var fileExists = dir.file_exists(SAVE_PATH)

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
	},
	"gameplay": {
		"background_particles": 1
	}
}

func _ready():
	if not fileExists:
		save_settings()
		load_settings()
		implement_settings()
	else:
		load_settings()
		implement_settings()

func save_settings():
	for section in settings.keys():
		for key in settings[section]:
			config_file.set_value(section, key, settings[section][key])
	
	config_file.save(SAVE_PATH)

func load_settings():
	var err = config_file.load(SAVE_PATH)
	if err != OK:
		printerr("Failed loading settings! Error code: " + err)
		return null
	
	for section in settings.keys():
		for key in settings[section]:
			settings[section][key] = config_file.set_value(section, key, null)

func implement_settings():
	get_config_file().load(get_config_file_path())
	
	OS.set_use_vsync(config_file.get_value("window", "v-sync"))
	AudioServer.set_bus_volume_db(0, config_file.get_value("audio", "master_volume"))
	AudioServer.set_bus_volume_db(1, config_file.get_value("audio", "sfx_volume"))
	AudioServer.set_bus_volume_db(2, config_file.get_value("audio", "music_volume"))
	
	get_node("/root/Background").set_setting(config_file.get_value("gameplay", "background_particles"))
	
	if config_file.get_value("window", "fullscreen") == true:
		OS.set_window_fullscreen(config_file.get_value("window", "fullscreen"))
	else:
		OS.set_window_size(config_file.get_value("window", "resolution"))
		OS.center_window()
	
	# Mute audio channels instead of being at -24db
	for i in range(3):
		if AudioServer.get_bus_volume_db(i) == -24:
			AudioServer.set_bus_mute(i, true)
		else:
			AudioServer.set_bus_mute(i, false)

func get_config_file():
	return config_file

func get_config_file_path():
	return SAVE_PATH