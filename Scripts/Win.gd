extends Control

func _on_MainMenuButton_pressed():
	get_node("/root/SFXPlayer").play_sfx("SFXBack")
	get_node("/root/MusicPlayer").play_menu_music()
	get_node("/root/global").goto_scene("res://Scenes/MainMenu.tscn")
