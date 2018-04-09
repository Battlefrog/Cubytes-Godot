extends Panel

func _on_PlayButton_pressed():
	# TODO: Arcade Mode needs to be here!!
	get_tree().change_scene("res://Scenes/ModeSelection.tscn")

func _on_QuitButton_pressed():
	get_tree().quit()
