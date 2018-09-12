extends VBoxContainer

func _on_PlayButton_pressed():
	get_node("/root/SFXPlayer").play_sfx("SFXAccept")
	get_node("/root/global").goto_scene("res://UI/Menus/ModeSelection.tscn")

func _on_QuitButton_pressed():
	get_tree().quit()

func _on_OptionsButton_pressed():
	get_node("/root/SFXPlayer").play_sfx("SFXAccept")
	get_node("/root/global").goto_scene("res://UI/Menus/Options.tscn")

func _on_HelpButton_pressed():
	get_node("/root/SFXPlayer").play_sfx("SFXAccept")
	get_node("/root/global").goto_scene("res://UI/Menus/Help.tscn")
