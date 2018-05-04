extends Panel

func _on_PlayButton_pressed():
	get_tree().change_scene("res://Scenes/ModeSelection.tscn")

func _on_QuitButton_pressed():
	get_tree().quit()

func _on_OptionsButton_pressed():
	get_tree().change_scene("res://Scenes/Options.tscn")
