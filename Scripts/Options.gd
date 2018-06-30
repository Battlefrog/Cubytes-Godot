extends Control

func _on_BackButton_pressed():
	get_node("/root/SFXPlayer").play_sfx("SFXBack")
	get_node("/root/global").goto_scene("res://Scenes/MainMenu.tscn")

func _on_VSync_toggled(button_pressed):
	get_node("/root/SFXPlayer").play_sfx("SFXAccept")
	OS.vsync_enabled = button_pressed

func _on_FullscreenToggle_pressed():
	get_node("/root/SFXPlayer").play_sfx("SFXAccept")
	OS.window_fullscreen = !OS.window_fullscreen