extends Control

var wanted_level

func _on_BackButton_pressed():
	get_node("/root/SFXPlayer").play_sfx("SFXBack")
	get_node("/root/global").goto_scene("res://Scenes/ModeSelection.tscn")

func level_pressed(num, description):
	get_node("/root/SFXPlayer").play_sfx("SFXAccept")
	
	$LevelDetails/LevelName.set_text("Level " + str(num))
	$LevelDetails/LevelDescription.set_text(description)

func _on_PlayButton_pressed():
	get_node("/root/SFXPlayer").play_sfx("SFXAccept")
	
	if $LevelDetails/LevelName.text == "Level 1":
		wanted_level = "res://Scenes/ArcadeLevels/Level1.tscn"
		if ProjectSettings.get_setting("completed_story_mode") == false:
			show_warning_popup()
		else:
			load_arcade_level()
	elif $LevelDetails/LevelName.text == "Level 2":
		wanted_level = "res://Scenes/ArcadeLevels/Level2.tscn"
		if ProjectSettings.get_setting("completed_story_mode") == false:
			show_warning_popup()
		else:
			load_arcade_level()
	elif $LevelDetails/LevelName.text == "Level 3":
		wanted_level = "res://Scenes/ArcadeLevels/Level3.tscn"
		if ProjectSettings.get_setting("completed_story_mode") == false:
			show_warning_popup()
		else:
			load_arcade_level()
	elif $LevelDetails/LevelName.text == "Level 4":
		wanted_level = "res://Scenes/ArcadeLevels/Level4.tscn"
		if ProjectSettings.get_setting("completed_story_mode") == false:
			show_warning_popup()
		else:
			load_arcade_level()
	elif $LevelDetails/LevelName.text == "Level 5":
		wanted_level = "res://Scenes/ArcadeLevels/Level5.tscn"
		if ProjectSettings.get_setting("completed_story_mode") == false:
			show_warning_popup()
		else:
			load_arcade_level()

func show_warning_popup():
	$LevelLoadWarning.popup()

func _on_YesButton_pressed():
	load_arcade_level()

func _on_NoButton_pressed():
	$LevelLoadWarning.hide()
	get_node("/root/SFXPlayer").play_sfx("SFXBack")

func load_arcade_level():
	$LevelLoadWarning.hide()
	get_node("/root/SFXPlayer").play_sfx("SFXAccept")
	get_node("/root/MusicPlayer").play_level_music()
	get_node("/root/global").goto_scene(wanted_level)
