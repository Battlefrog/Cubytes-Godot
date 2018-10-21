extends Control

onready var save_file = get_node("/root/Save").get_config_file_path()
onready var save = get_node("/root/Save").get_config_file()

func _ready():
	save.load(save_file)
	
	ProjectSettings.set_setting("completed_story_mode", true)

func _on_MainMenuButton_pressed():
	get_node("/root/AudioPlayer").play_sfx("SFXBack")
	get_node("/root/AudioPlayer").play_menu_music()
	get_node("/root/global").goto_scene("res://UI/Menus/MainMenu.tscn")

func save_game():
	save.set_value("story", "completed_story_mode", true)
	save.save(save_file)