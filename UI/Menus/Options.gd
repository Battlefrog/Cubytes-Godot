extends Control

onready var config_file = get_node("/root/Settings").get_config_file_path()
onready var config = get_node("/root/Settings").get_config_file()
onready var save_file = get_node("/root/Save").get_config_file_path()
onready var save = get_node("/root/Save").get_config_file()

var cheat = preload("res://UI/Menus/CheatDisplay.tscn")
var vsync
var fullscreen
var master_slider
var music_slider
var sfx_slider
var resolution

var cheats = {
	"debug_mode": 0,
	"click_teleport": 1
}

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
	
	$TabContainer/Graphics/Resolution/Resolutions.add_item("1920x1080", 0)
	$TabContainer/Graphics/Resolution/Resolutions.add_item("1600x900", 1)
	$TabContainer/Graphics/Resolution/Resolutions.add_item("1336x768", 2)
	$TabContainer/Graphics/Resolution/Resolutions.add_item("1280x720", 3)
	
	$TabContainer/Graphics/BackgroundParticles/ParticleSettings.add_item("High", 0)
	$TabContainer/Graphics/BackgroundParticles/ParticleSettings.add_item("Medium", 1)
	$TabContainer/Graphics/BackgroundParticles/ParticleSettings.add_item("Low", 2)
	$TabContainer/Graphics/BackgroundParticles/ParticleSettings.add_item("Off", 3)

func load_config():
	config.load(config_file)
	save.load(save_file)

func save_config():
	config.set_value("window", "v-sync", get_node("TabContainer/Graphics/VsyncToggle").is_pressed())
	config.set_value("window", "fullscreen", get_node("TabContainer/Graphics/FullscreenToggle").is_pressed())
	config.set_value("window", "resolution", resolution)
	config.set_value("audio", "master_volume", get_node("TabContainer/Audio/MasterText/MasterSlider").get_value())
	config.set_value("audio", "music_volume", get_node("TabContainer/Audio/MusicText/MusicSlider").get_value())
	config.set_value("audio", "sfx_volume", get_node("TabContainer/Audio/SFXText/SFXSlider").get_value())
	
	if $TabContainer/Gameplay/CheatViewerPanelText/CheatViewerPanel/ActiveCheats.get_children().size() > 0 and save.get_value("story", "used_cheats") == false:
		save.set_value("story", "used_cheats", true)
	
	config.save(config_file)
	save.save(save_file)

func _on_BackButton_pressed():
	save_config()
	
	get_node("/root/AudioPlayer").play_sfx("SFXBack")
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
	get_node("/root/AudioPlayer").play_sfx("SFXAccept")

func activate_cheat(cheat):
	$TabContainer/Gameplay/CheatViewerPanelText/CheatViewerPanel/ActiveCheats.add_child(cheat)
	#set_cheat_warning("Cheat activated!", true)
	
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
							set_cheat_warning("Cheat already activated!", false)
							b = true
							break
						else:
							continue
				if not b:
					activate_cheat(cheat_instance)
	else:
		set_cheat_warning("Incorrect Cheat!", false)
	$TabContainer/Gameplay/CheatEnter.clear()

func _on_Resolutions_selected(ID):
	get_node("/root/AudioPlayer").play_sfx("SFXAccept")
	var text = $TabContainer/Graphics/Resolution/Resolutions.get_item_text(ID)
	var width = text.substr(0, text.findn("x"))
	var height = text.right(text.findn("x") + 1)
	_on_resolution_changed(width, height)

func _on_ParticleSettings_item_selected(ID):
	get_node("/root/Background").set_setting(ID)

func set_cheat_warning(text, is_good):
	# TODO: This removes the oversampled text goodness and creates a pixelated mess.
	# Hopefully 3.1 fixes this, it fixes 2 issues with oversampled text already.
	#if is_good:
		#$TabContainer/Gameplay/CheatWarning.add_color_override("font_color", Color(51, 204, 51, 255))
	#else:
		#$TabContainer/Gameplay/CheatWarning.add_color_override("font_color", Color(255, 0, 0, 255))
	
	$TabContainer/Gameplay/CheatWarning.set_text(text)
	$TabContainer/Gameplay/CheatWarning.show()