extends Control

func _on_StoryModeButton_pressed():
	get_node("/root/SFXPlayer").play_sfx("SFXStartStoryMode")
	get_node("/root/global").goto_scene("res://Scenes/StoryLevels/Level1.tscn")

func _on_BackButton_pressed():
	get_node("/root/SFXPlayer").play_sfx("SFXBack")
	get_node("/root/global").goto_scene("res://Scenes/MainMenu.tscn")

func _on_ArcadeModeButton_pressed():
	get_node("/root/SFXPlayer").play_sfx("SFXAccept")
	get_node("/root/global").goto_scene("res://Scenes/ArcadeMode.tscn")
