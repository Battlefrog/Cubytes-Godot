extends Control

onready var save_file = get_node("/root/Save").get_config_file_path()
onready var save = get_node("/root/Save").get_config_file()

func _ready():
	save.load(save_file)
	
	if save.get_value("story", "on_level") != "Level1":
		$ButtonPanel/StoryModeButton.set_text("Resume (" + save.get_value("story", "on_level") + ")")
		$DeleteSaveButton.show()
	else:
		$ButtonPanel/StoryModeButton.set_text("Story")
		$DeleteSaveButton.hide()

func _on_StoryModeButton_pressed():
	get_node("/root/MusicPlayer").play_level_music()
	get_node("/root/SFXPlayer").play_sfx("SFXStartStoryMode")
	
	if save.get_value("story", "on_level") == "Level1":
		get_node("/root/global").goto_scene("res://Levels/Story/Level1.tscn")
	else:
		get_node("/root/global").goto_scene("res://Levels/Story/" + save.get_value("story", "on_level") + ".tscn")

func _on_BackButton_pressed():
	get_node("/root/SFXPlayer").play_sfx("SFXBack")
	get_node("/root/global").goto_scene("res://UI/Menus/MainMenu.tscn")

func _on_ArcadeModeButton_pressed():
	get_node("/root/SFXPlayer").play_sfx("SFXAccept")
	get_node("/root/global").goto_scene("res://UI/Menus/ArcadeMode.tscn")

func _on_DeleteSaveButton_pressed():
	get_node("/root/Save").delete_save()
	$ButtonPanel/StoryModeButton.set_text("Story")
	$DeleteSaveButton.hide()
