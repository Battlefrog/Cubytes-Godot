extends Control

var fullscreen = OS.window_fullscreen

func _process(delta):
	#print(OS.is_window_fullscreen())
	# print($Panel/Fullscreen/FullScreenToggle.toggle_mode)
	
	if (OS.is_window_fullscreen()):
		$Panel/Fullscreen/FullScreenToggle.set_toggle_mode(true)
		
	if (OS.is_vsync_enabled()):
		$"Panel/V-Sync/VsyncToggle".set_toggle_mode(true)

func _on_BackButton_pressed():
	get_node("/root/global").goto_scene("res://Scenes/MainMenu.tscn")
	
func _on_Fullscreen_toggled(button_pressed):
	OS.set_window_fullscreen(button_pressed)

func _on_VSync_toggled(button_pressed):
	OS.set_use_vsync(button_pressed)
