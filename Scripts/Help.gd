extends Control

func _on_BackButton_pressed():
	get_node("/root/SFXPlayer").play_sfx("SFXBack")
	get_node("/root/global").goto_scene("res://Scenes/MainMenu.tscn")
