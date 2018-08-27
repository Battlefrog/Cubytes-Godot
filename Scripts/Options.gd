extends Control

func _ready():
	$TabContainer/Window/VsyncToggle.pressed = OS.is_vsync_enabled()
	$TabContainer/Window/FullscreenToggle.pressed = OS.is_window_fullscreen()

func _on_BackButton_pressed():
	get_node("/root/SFXPlayer").play_sfx("SFXBack")
	get_node("/root/global").goto_scene("res://Scenes/MainMenu.tscn")

func _on_VSync_toggled(button_pressed):
	OS.vsync_enabled = button_pressed

func _on_FullscreenToggle_pressed():
	OS.window_fullscreen = !OS.window_fullscreen

func _on_slider_changed(value, slider_id):
	AudioServer.set_bus_volume_db(slider_id, value)
	
	if (value == -12):
		AudioServer.set_bus_mute(slider_id, true)
	else:
		AudioServer.set_bus_mute(slider_id, false)

func _on_resolution_changed(width, height):
	if (!OS.is_window_fullscreen()):
		OS.set_window_size(Vector2(width, height))
		OS.center_window()
	else:
		var window_size = Vector2(width, height)
		
    	# see how big the window is compared to the viewport size
    	# floor it so we only get round numbers (0, 1, 2, 3 ...)
		var scale_x = floor(window_size.x / get_viewport().size.x)
		var scale_y = floor(window_size.y / get_viewport().size.y)
		
		# use the smaller scale with 1x minimum scale
		var scale = max(1, min(scale_x, scale_y))
		
		# find the coordinate we will use to center the viewport inside the window
		var diff = window_size - (get_viewport().size * scale)
		var diffhalf = (diff * 0.5).floor()
		
		# attach the viewport to the rect we calculated
		get_viewport().set_attach_to_screen_rect(Rect2(diffhalf, get_viewport().size * scale))

func _on_TabContainer_tab_selected(tab):
	get_node("/root/SFXPlayer").play_sfx("SFXAccept")
