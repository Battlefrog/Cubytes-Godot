extends Control

func _ready():
	$TabContainer/Graphics/VsyncToggle.pressed = OS.is_vsync_enabled()
	$TabContainer/Graphics/FullscreenToggle.pressed = OS.is_window_fullscreen()

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

# TODO: Allow multiple fullscreen resolutions.
func _on_resolution_changed(width, height):
	if (!OS.is_window_fullscreen()):
		OS.set_window_size(Vector2(width, height))
		OS.center_window()

func _on_TabContainer_tab_selected(tab):
	get_node("/root/SFXPlayer").play_sfx("SFXAccept")
