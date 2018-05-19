extends Node2D

var fullscreen = OS.window_fullscreen

func _on_BackButton_pressed():
	get_node("/root/global").goto_scene("res://Scenes/MainMenu.tscn")
	
func _on_Fullscreen_toggled(button_pressed):
	OS.set_window_fullscreen(button_pressed)
