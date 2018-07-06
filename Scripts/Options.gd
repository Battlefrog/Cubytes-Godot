extends Control

func _ready():
	$Panel/VsyncToggle.pressed = OS.is_vsync_enabled()
	$Panel/FullscreenToggle.pressed = OS.is_window_fullscreen()

func _on_BackButton_pressed():
	get_node("/root/SFXPlayer").play_sfx("SFXBack")
	get_node("/root/global").goto_scene("res://Scenes/MainMenu.tscn")

func _on_VSync_toggled(button_pressed):
	OS.vsync_enabled = button_pressed

func _on_FullscreenToggle_pressed():
	OS.window_fullscreen = !OS.window_fullscreen