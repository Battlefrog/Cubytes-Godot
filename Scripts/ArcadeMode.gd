extends Control

func _on_BackButton_pressed():
	get_node("/root/SFXPlayer").play_sfx("SFXBack")
	get_node("/root/global").goto_scene("res://Scenes/ModeSelection.tscn")

func level_pressed(num, description):
	get_node("/root/SFXPlayer").play_sfx("SFXAccept")
	
	$LevelDetails/LevelName.set_text("Level " + str(num))
	$LevelDetails/LevelDescription.set_text(description)

func _on_PlayButton_pressed():
	if $LevelDetails/LevelName.text == "Level 1":
		show_warning_popup("res://Scenes/Levels/ArcadeLevels/Level1.tscn")
	elif $LevelDetails/LevelName.text == "Level 2":
		show_warning_popup("res://Scenes/Levels/ArcadeLevels/Level2.tscn")
	elif $LevelDetails/LevelName.text == "Level 3":
		show_warning_popup("res://Scenes/Levels/ArcadeLevels/Level3.tscn")
	elif $LevelDetails/LevelName.text == "Level 4":
		show_warning_popup("res://Scenes/Levels/ArcadeLevels/Level4.tscn")
	elif $LevelDetails/LevelName.text == "Level 5":
		show_warning_popup("res://Scenes/Levels/ArcadeLevels/Level5.tscn")

func show_warning_popup(level):
	$LevelLoadWarning.popup()

func _on_YesButton_pressed():
	pass # replace with function body

func _on_NoButton_pressed():
	pass # replace with function body
