extends Node

signal game_unpaused
signal game_paused

export (int) var current_level_num

var is_paused = false
var block_tutorial_active = false

onready var EndBlock = get_node("../EndBlock")
onready var save_file = get_node("/root/Save").get_config_file_path()
onready var save = get_node("/root/Save").get_config_file()

func _ready():
	save.load(save_file)
	get_tree().set_pause(false)
	get_node("../Player").connect("player_died", self, "update_death_display")
	
	if has_node("../BlockTutorial"):
		get_node("../BlockTutorial").connect("block_tutorial", self, "show_block_tutorial")
	
	# To make sure that the deaths are shown when the level is loaded
	if not EndBlock.is_arcade_mode():
		var death = ProjectSettings.get_setting("player_deaths")
		update_death_display(death)
	else:
		$DeathDisplay.hide()
	
	$pause.hide()
	$pause.set_exclusive(true)
	$BlockTutorial.hide()
	$BlockTutorial.set_exclusive(false)
	$PauseFade.hide()
	
	$LevelDisplay.set_text("Level: " + str(current_level_num))

func _process(delta):
	if ProjectSettings.get_setting("show_fps"):
		$FPSDisplay.set_text("FPS: " + str(Performance.get_monitor(Performance.TIME_FPS)))
	
	if block_tutorial_active:
		if Input.is_action_pressed("ui_accept"):
			$BlockTutorial.hide()
	
	if Input.is_action_just_pressed("debug_mode_nextlevel") and not EndBlock.is_arcade_mode():
		if ProjectSettings.get_setting("debug_mode"):
			get_node("/root/global").goto_scene("res://Levels/Story/" + EndBlock.get_next_level() + ".tscn")
	
	if !is_paused:
		if Input.is_action_just_pressed("ui_cancel"):
			pause_game()
	else:
		if Input.is_action_just_pressed("ui_cancel"):
			unpause_game()

func update_death_display(death):
	if not EndBlock.is_arcade_mode():
		$DeathDisplay.set_text("Deaths: " + str(death))

func pause_game():
	emit_signal("game_paused")
	$PauseFade.show()
	get_node("/root/AudioPlayer").stop_music()
	$pause.popup()
	get_tree().set_pause(true)
	is_paused = true

func _on_ResumeButton_pressed():
	get_node("/root/AudioPlayer").play_sfx("SFXAccept")
	unpause_game()

func unpause_game():
	get_node("/root/AudioPlayer").play_level_music()
	$PauseFade.hide()
	$pause.hide()
	get_tree().set_pause(false)
	emit_signal("game_unpaused")
	is_paused = false

func _on_MainMenuButton_pressed():
	$PauseFade.hide()
	# So the Main Menu doesn't get paused!
	get_tree().set_pause(false)
	get_node("/root/AudioPlayer").play_sfx("SFXBack")
	get_node("/root/AudioPlayer").play_menu_music()
	get_node("/root/global").goto_scene("res://UI/Menus/MainMenu.tscn")
	emit_signal("game_unpaused")

func _on_RestartButton_pressed():
	$PauseFade.hide()
	$pause.hide()
	get_node("/root/AudioPlayer").play_level_music()
	get_node("/root/AudioPlayer").play_sfx("SFXAccept")
	get_node("/root/global").goto_scene(get_tree().get_current_scene().get_filename())
	get_tree().set_pause(false)
	emit_signal("game_unpaused")

func show_block_tutorial(block_text, texture_path, block_name):
	$BlockTutorial/Container/BlockText.text = block_text
	$BlockTutorial/Container/BlockImage.texture = texture_path
	$BlockTutorial/Container/BlockName.text = block_name
	
	get_node("/root/AudioPlayer").stop_music()
	$BlockTutorial.popup()
	get_tree().set_pause(true)
	block_tutorial_active = true
	emit_signal("game_paused")

func _on_BlockTutorial_popup_hide():
	get_tree().set_pause(false)
	get_node("/root/AudioPlayer").play_level_music()
	emit_signal("game_unpaused")

func get_current_level_num():
	return current_level_num

func save_game():
	if not EndBlock.is_arcade_mode():
		var current_level = "Level" + str(get_current_level_num())
		save.set_value("story", "player_deaths", ProjectSettings.get_setting("player_deaths"))
		save.set_value("story", "on_level", current_level)
		save.save(save_file)

func shake(duration = 0.2, frequency = 15, amplitude = 16, priority = 0):
	$Camera2D/ScreenShake.start(duration, frequency, amplitude, priority)