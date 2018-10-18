extends Node

const SAVE_PATH = "res://user_save.save"

var dir = Directory.new()
var fileExists = dir.file_exists(SAVE_PATH)

var config_file = ConfigFile.new()

# Default save, also what the file looks like
var save = {
	"story": {
		"on_level": "Level1",
		"player_deaths": 0,
		"completed_story_mode": false,
		"used_cheats": false
	},
	"arcade": {
		"arcade_highscores": [0,0,0,0,0,0,0,0]
	}
}

func _ready():
	if not fileExists:
		save_game()
		load_game()
		implement_save()
	else:
		load_game()
		implement_save()

func save_game():
	for section in save.keys():
		for key in save[section]:
			config_file.set_value(section, key, save[section][key])
	
	config_file.save(SAVE_PATH)

func load_game():
	var err = config_file.load(SAVE_PATH)
	if err != OK:
		printerr("Failed loading settings! Error code: " + err)
		return null
	
	for section in save.keys():
		for key in save[section]:
			save[section][key] = config_file.set_value(section, key, null)

func implement_save():
	get_config_file().load(get_config_file_path())
	
	var deaths = config_file.get_value("story", "player_deaths")
	
	ProjectSettings.set_setting("on_level", config_file.get_value("story", "on_level"))
	ProjectSettings.set_setting("player_deaths", deaths)
	ProjectSettings.set_setting("completed_story_mode", config_file.get_value("story", "completed_story_mode"))
	ProjectSettings.set_setting("used_cheats", config_file.get_value("story", "used_cheats"))
	
	var highscores = config_file.get_value("arcade", "arcade_highscores")
	var num = 1
	
	for score in highscores:
		get_node("/root/scores").add_to_highscores(score, num)
		num += 1
		
	print(ProjectSettings.get_setting("player_deaths"))

func get_config_file():
	return config_file

func get_config_file_path():
	return SAVE_PATH

func delete_save():
	if dir.file_exists(SAVE_PATH):
		dir.remove(SAVE_PATH)
		save_game()
		load_game()
		implement_save()