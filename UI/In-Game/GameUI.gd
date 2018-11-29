extends Node

export (int) var current_level_num

var is_paused = false
var block_tutorial_active = false

onready var save_file = get_node("/root/Save").get_config_file_path()
onready var save = get_node("/root/Save").get_config_file()

signal game_unpaused
signal game_paused

func _ready():
	save.load(save_file)
	
	get_tree().set_pause(false)
	
	get_node("../Player").connect("player_died", self, "update_death_display")
	get_node("../Player").connect("pause_game", self, "pause_game")
	
	if has_node("../BlockTutorial"):
		get_node("../BlockTutorial").connect("block_tutorial", self, "show_block_tutorial")
	
	# To make sure that the deaths are shown when the level is loaded
	var death = ProjectSettings.get_setting("player_deaths")
	print(death)
	update_death_display(death)
	
	$pause.hide()
	$pause.set_exclusive(true)
	
	$BlockTutorial.hide()
	$BlockTutorial.set_exclusive(false)
	
	$PauseFade.hide()

func _process(delta):
	$LevelDisplay.set_text("Level: " + str(current_level_num))
	if ProjectSettings.get_setting("show_fps"):
		$FPSDisplay.set_text("FPS: " + str(Performance.get_monitor(Performance.TIME_FPS)))
	
	if block_tutorial_active:
		if Input.is_action_pressed("ui_accept"):
			$BlockTutorial.hide()
	
	if Input.is_action_just_pressed("debug_mode_nextlevel"):
		if ProjectSettings.get_setting("debug_mode"):
			get_node("/root/global").goto_scene("res://Levels/Story/" + get_node("../EndBlock").get_next_level() + ".tscn")

func update_death_display(death):
	$DeathDisplay.set_text("Deaths: " + str(death))

func pause_game():
	emit_signal("game_paused")
	$PauseFade.show()
	get_node("/root/AudioPlayer").stop_music()
	$pause.popup()
	get_tree().set_pause(true)

func _on_ResumeButton_pressed():
	$PauseFade.hide()
	get_node("/root/AudioPlayer").play_sfx("SFXAccept")
	get_node("/root/AudioPlayer").play_level_music()
	$pause.hide()
	get_tree().set_pause(false)
	emit_signal("game_unpaused")

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
	var current_level = "Level" + str(get_current_level_num())
	
	save.set_value("story", "player_deaths", ProjectSettings.get_setting("player_deaths"))
	save.set_value("story", "on_level", current_level)
	save.save(save_file)

func shake(duration = 0.2, frequency = 15, amplitude = 16, priority = 0):
	$Camera2D/ScreenShake.start(duration, frequency, amplitude, priority)