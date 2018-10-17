extends Control

var cheats = {
	"debug_mode": 0,
	"click_teleport": 1
}

var cheat = preload("res://UI/Menus/CheatDisplay.tscn")

onready var config_file = get_node("/root/Settings").get_config_file_path()
onready var config = get_node("/root/Settings").get_config_file()

var vsync
var fullscreen
var master_slider
var music_slider
var sfx_slider
var resolution

func load_config():
	config.load(config_file)

func save_config():
	config.set_value("window", "v-sync", get_node("TabContainer/Graphics/VsyncToggle").is_pressed())
	config.set_value("window", "fullscreen", get_node("TabContainer/Graphics/FullscreenToggle").is_pressed())
	config.set_value("window", "resolution", resolution)
	config.set_value("audio", "master_volume", get_node("TabContainer/Audio/MasterText/MasterSlider").get_value())
	config.set_value("audio", "music_volume", get_node("TabContainer/Audio/MusicText/MusicSlider").get_value())
	config.set_value("audio", "sfx_volume", get_node("TabContainer/Audio/SFXText/SFXSlider").get_value())
	
	config.save(config_file)

func _ready():
	load_config()
	
	vsync = config.get_value("window", "v-sync")
	fullscreen = config.get_value("window", "fullscreen")
	resolution = config.get_value("window", "resolution")
	master_slider = config.get_value("audio", "master_volume")
	music_slider = config.get_value("audio", "music_volume")
	sfx_slider = config.get_value("audio", "sfx_volume")
	
	$TabContainer/Graphics/VsyncToggle.set_pressed(vsync)
	$TabContainer/Graphics/FullscreenToggle.set_pressed(fullscreen)
	$TabContainer/Audio/MasterText/MasterSlider.set_value(master_slider)
	$TabContainer/Audio/MusicText/MusicSlider.set_value(music_slider)
	$TabContainer/Audio/SFXText/SFXSlider.set_value(sfx_slider)
	_on_resolution_changed(resolution.x, resolution.y)
	
	# Loading cheat display for cheats already activated beforehand
	for i in cheats:
		if ProjectSettings.get_setting(i):
			var cheat_instance = cheat.instance()
			cheat_instance.set_name(i)
			cheat_instance.set_text(i)
			activate_cheat(cheat_instance)

func _on_BackButton_pressed():
	save_config()
	
	get_node("/root/SFXPlayer").play_sfx("SFXBack")
	get_node("/root/global").goto_scene("res://UI/Menus/MainMenu.tscn")

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

func _on_resolution_changed(width, height):
	if (!OS.is_window_fullscreen()):
		OS.set_window_size(Vector2(width, height))
		OS.center_window()
		resolution = Vector2(width, height)

func _on_TabContainer_tab_selected(tab):
	get_node("/root/SFXPlayer").play_sfx("SFXAccept")

func activate_cheat(cheat):
	$TabContainer/Gameplay/CheatViewerPanelText/CheatViewerPanel/ActiveCheats.add_child(cheat)
	$TabContainer/Gameplay/CheatWarning.hide()
	
	var exit = cheat.get_child(0)
	exit.connect("pressed", self, "on_cheat_clear_pressed", [cheat])
	
	if not ProjectSettings.get_setting(cheat.get_name()):
		ProjectSettings.set_setting(cheat.get_name(), true)

func deactivate_cheat(cheat):
	$TabContainer/Gameplay/CheatViewerPanelText/CheatViewerPanel/ActiveCheats.remove_child(cheat)
	$TabContainer/Gameplay/CheatWarning.hide()
	
	if ProjectSettings.get_setting(cheat.get_name()):
		ProjectSettings.set_setting(cheat.get_name(), false)

func on_cheat_clear_pressed(cheat):
	deactivate_cheat(cheat)

func _on_Cheat_text_entered(new_text):
	var b
	if cheats.has(new_text):
			$TabContainer/Gameplay/CheatWarning.hide()
			var cheat_instance = cheat.instance()
			cheat_instance.set_name(new_text)
			cheat_instance.set_text(new_text)
			
			if $TabContainer/Gameplay/CheatViewerPanelText/CheatViewerPanel/ActiveCheats.get_children().size() == 0:
				activate_cheat(cheat_instance)
			else:
				for child in $TabContainer/Gameplay/CheatViewerPanelText/CheatViewerPanel/ActiveCheats.get_children():
					for cheat in cheats:
						if child.get_text() == cheat and new_text == cheat:
							$TabContainer/Gameplay/CheatWarning.set_text("Cheat already activated!")
							$TabContainer/Gameplay/CheatWarning.show()
							b = true
							break
						else:
							continue
				if not b:
					activate_cheat(cheat_instance)
	else:
		$TabContainer/Gameplay/CheatWarning.set_text("Incorrect cheat!")
		$TabContainer/Gameplay/CheatWarning.show()
	$TabContainer/Gameplay/CheatEnter.clear()