extends Control

var wanted_level
var wanted_level_num = 0

func _ready():
	$LevelList/Levels/row/Level1.connect("pressed", self, "level_pressed", [1, "Bombs, bombs, and bombs. Oh my!"])
	$LevelList/Levels/row/Level2.connect("pressed", self, "level_pressed", [2, "One block gaps aren't really hard to get through... right?"])
	$LevelList/Levels/row2/Level3.connect("pressed", self, "level_pressed", [3, "Has some cool patterns and figures. Like any psychedelic."])
	$LevelList/Levels/row2/Level4.connect("pressed", self, "level_pressed", [4, "Multiple paths, one seemly better than the other..."])
	$LevelList/Levels/row3/Level5.connect("pressed", self, "level_pressed", [5, "Better go quick, or the black holes will suck you in!"])
	$LevelList/Levels/row3/Level6.connect("pressed", self, "level_pressed", [6, "Hey. Lasers can perform the same function as blocks - keeping players out!"])
	$LevelList/Levels/row4/Level7.connect("pressed", self, "level_pressed", [7, "Players like to be spawned in from the End Block as far away as possible...right?"])
	$LevelList/Levels/row4/Level8.connect("pressed", self, "level_pressed", [8, "Difficulty through simplicity."])
	$LevelDetails.show()
	$HighScore.hide()
	
	# Quick and dirty hack for getting the Level1 information to show at the start.
	$LevelList/Levels/row/Level1.emit_signal("pressed")

func _on_BackButton_pressed():
	get_node("/root/AudioPlayer").play_sfx("SFXBack")
	get_node("/root/global").goto_scene("res://UI/Menus/ModeSelection.tscn")

func level_pressed(num, description):
	get_node("/root/AudioPlayer").play_sfx("SFXAccept")
	
	$LevelDetails/LevelName.set_text("Level " + str(num))
	$LevelDetails/LevelDescription.set_text(description)
	
	if num != 0:
		change_highscore_menu(num)
	
	wanted_level_num = num

func _on_PlayButton_pressed():
	get_node("/root/AudioPlayer").play_sfx("SFXAccept")
	wanted_level = "res://Levels/Arcade/Level" + str(wanted_level_num) + ".tscn"
	play_button_check()

func play_button_check():
	if ProjectSettings.get_setting("completed_story_mode") == false:
		show_warning_popup()
	else:
		load_arcade_level()

func show_warning_popup():
	$LevelLoadWarning.popup()

func _on_YesButton_pressed():
	load_arcade_level()

func _on_NoButton_pressed():
	get_node("/root/AudioPlayer").play_sfx("SFXBack")
	$LevelLoadWarning.hide()

func load_arcade_level():
	$LevelLoadWarning.hide()
	get_node("/root/AudioPlayer").play_sfx("SFXAccept")
	get_node("/root/AudioPlayer").play_level_music()
	get_node("/root/global").goto_scene(wanted_level)

func _on_HighScoreButton_pressed():
	if wanted_level_num != 0:
		get_node("/root/AudioPlayer").play_sfx("SFXAccept")
		$LevelDetails.hide()
		$HighScore.show()

func _on_HighScoreBack_pressed():
	get_node("/root/AudioPlayer").play_sfx("SFXBack")
	$LevelDetails.show()
	$HighScore.hide()

func change_highscore_menu(num):
	var time = get_node("/root/scores").get_highscore(num)
	print(time)
	
	$HighScore/Level.set_text("Level " + str(num) + ":")
	$HighScore/Time.set_text(str(time) + " sec")