extends Node

export (int) var current_level_num

var is_paused = false

func _ready():
	get_node("../Player").connect("player_died", self, "update_death_display")
	get_node("../Player").connect("pause_game", self, "pause_game")
	
	var death = ProjectSettings.get_setting("PLAYER_DEATHS")
	update_death_display(death)
	
	$pause.hide()
	$pause.set_exclusive(true)
	
func _process(delta):
	$LevelDisplay.set_text("Level: " + str(current_level_num))
	$FPSDisplay.set_text("FPS: " + str(Performance.get_monitor(Performance.TIME_FPS)))
	
func update_death_display(death):
	$DeathDisplay.set_text("Deaths: " + str(death))
	
func pause_game():
	get_node("/root/MusicPlayer").stop_music()
	$pause.popup()
	get_tree().set_pause(true)

func _on_ResumeButton_pressed():
	get_node("/root/MusicPlayer").play_level_music()
	$pause.hide()
	get_tree().set_pause(false)

func _on_MainMenuButton_pressed():
	# So the Main Menu doesn't get paused!
	get_tree().set_pause(false)
	get_node("/root/MusicPlayer").play_menu_music()
	get_node("/root/global").goto_scene("res://Scenes/MainMenu.tscn")