extends Node

export (int) var current_level_num

var is_paused = false

func _ready():
	get_node("../Player").connect("player_died", self, "update_death_display")
	get_node("../Player").connect("pause_game", self, "pause_game")
	
	if has_node("../BlockTutorial"):
		get_node("../BlockTutorial").connect("block_tutorial", self, "show_block_tutorial")
	
	# To make sure that the deaths are shown when the level is loaded
	var death = ProjectSettings.get_setting("PLAYER_DEATHS")
	update_death_display(death)
	
	$pause.hide()
	$pause.set_exclusive(true)
	
	$BlockTutorial.hide()
	$BlockTutorial.set_exclusive(false)
	
	$PauseFade.hide()

func _process(delta):
	$LevelDisplay.set_text("Level: " + str(current_level_num))
	$FPSDisplay.set_text("FPS: " + str(Performance.get_monitor(Performance.TIME_FPS)))

func update_death_display(death):
	$DeathDisplay.set_text("Deaths: " + str(death))

func pause_game():
	$PauseFade.show()
	get_node("/root/MusicPlayer").stop_music()
	$pause.popup()
	get_tree().set_pause(true)

func _on_ResumeButton_pressed():
	$PauseFade.hide()
	get_node("/root/SFXPlayer").play_sfx("SFXAccept")
	get_node("/root/MusicPlayer").play_level_music()
	$pause.hide()
	get_tree().set_pause(false)

func _on_MainMenuButton_pressed():
	$PauseFade.hide()
	# So the Main Menu doesn't get paused!
	get_tree().set_pause(false)
	get_node("/root/SFXPlayer").play_sfx("SFXBack")
	get_node("/root/MusicPlayer").play_menu_music()
	get_node("/root/global").goto_scene("res://Scenes/MainMenu.tscn")

func _on_RestartButton_pressed():
	$PauseFade.hide()
	$pause.hide()
	get_node("/root/MusicPlayer").play_level_music()
	get_node("/root/SFXPlayer").play_sfx("SFXAccept")
	get_node("/root/global").goto_scene(get_tree().get_current_scene().get_filename())
	get_tree().set_pause(false)

func show_block_tutorial(block_text, texture_path, block_name):
	$BlockTutorial/BlockText.text = block_text
	$BlockTutorial/BlockImage.texture = texture_path
	$BlockTutorial/BlockName.text = block_name
	
	get_node("/root/MusicPlayer").stop_music()
	$BlockTutorial.popup()
	get_tree().set_pause(true)

func _on_BlockTutorial_popup_hide():
	get_tree().set_pause(false)
	get_node("/root/MusicPlayer").play_level_music()