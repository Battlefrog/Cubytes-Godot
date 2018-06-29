extends Control

# Actual buttons
var fullscreen
var vsync

var is_fullscreen
var is_vsync

func _ready():
	fullscreen = $Panel/Fullscreen/FullScreenToggle
	vsync = $Panel/VSync/VsyncToggle
	
	if OS.is_window_fullscreen():
		is_fullscreen = true
	else:
		is_fullscreen = false
		
	if OS.is_vsync_enabled():
		is_vsync = true
	else:
		is_vsync = false

func _on_BackButton_pressed():
	get_node("/root/SFXPlayer").play_sfx("SFXBack")
	get_node("/root/global").goto_scene("res://Scenes/MainMenu.tscn")

func _on_Fullscreen_toggled(button_pressed):
	get_node("/root/SFXPlayer").play_sfx("SFXAccept")
	OS.set_window_fullscreen(button_pressed)
	is_fullscreen = button_pressed()

func _on_VSync_toggled(button_pressed):
	get_node("/root/SFXPlayer").play_sfx("SFXAccept")
	OS.set_use_vsync(button_pressed)
	is_vsync = button_pressed()

func _on_FullScreenToggle_draw():
	$Panel/Fullscreen/FullScreenToggle.set_toggle_mode(is_fullscreen)

func _on_VsyncToggle_draw():
	$Panel/VSync/VsyncToggle.set_toggle_mode(is_vsync)
