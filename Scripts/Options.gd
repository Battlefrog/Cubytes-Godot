extends Control

var cheats = {
	"debug_mode": 0,
	"click_teleport": 1
}

var cheat = preload("res://Scenes/CheatDisplay.tscn")

func _ready():
	$TabContainer/Graphics/VsyncToggle.pressed = OS.is_vsync_enabled()
	$TabContainer/Graphics/FullscreenToggle.pressed = OS.is_window_fullscreen()
	
	$TabContainer/Audio/MasterText/MasterSlider.set_value(AudioServer.get_bus_volume_db(0))
	$TabContainer/Audio/MusicText/MusicSlider.set_value(AudioServer.get_bus_volume_db(2))
	$TabContainer/Audio/SFXText/SFXSlider.set_value(AudioServer.get_bus_volume_db(1))

func _on_BackButton_pressed():
	get_node("/root/SFXPlayer").play_sfx("SFXBack")
	get_node("/root/global").goto_scene("res://Scenes/MainMenu.tscn")

func _on_VSync_toggled(button_pressed):
	OS.vsync_enabled = button_pressed

func _on_FullscreenToggle_pressed():
	OS.window_fullscreen = !OS.window_fullscreen

func _on_slider_changed(value, slider_id):
	AudioServer.set_bus_volume_db(slider_id, value)
	
	if (value == -24):
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

func activate_cheat(cheat):
	$TabContainer/Gameplay/CheatViewerPanelText/CheatViewerPanel/ActiveCheats.add_child(cheat)
	$TabContainer/Gameplay/IncorrectCheatText.hide()
	
	ProjectSettings.set_setting(cheat.get_name(), true)
	print(ProjectSettings.get_setting(cheat.get_name()))

func _on_Cheat_text_entered(new_text):
	if cheats.has(new_text):
			$TabContainer/Gameplay/IncorrectCheatText.hide()
			var cheat_instance = cheat.instance()
			cheat_instance.set_name(new_text)
			cheat_instance.set_text(new_text)
			
			if $TabContainer/Gameplay/CheatViewerPanelText/CheatViewerPanel/ActiveCheats.get_children().size() == 0:
				activate_cheat(cheat_instance)
			else:
				for child in $TabContainer/Gameplay/CheatViewerPanelText/CheatViewerPanel/ActiveCheats.get_children():
					if child.get_text() == "debug_mode" and new_text == "debug_mode":
						break
					elif child.get_text() == "click_teleport" and new_text == "click_teleport":
						break
					else:
						activate_cheat(cheat_instance)
	else:
		$TabContainer/Gameplay/IncorrectCheatText.show()
	$TabContainer/Gameplay/CheatEnter.clear()