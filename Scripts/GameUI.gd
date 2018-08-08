extends Node

export (int) var current_level_num

var is_paused = false

var BlockImage = {
	"RedBlock": preload("res://Sprites/Block.png"),
	"BombBlock": preload("res://Sprites/Bomb.png"),
	"ShrinkBlock": preload("res://Sprites/DecreaseSize.png"),
	"EndBlock": preload("res://Sprites/EndBlock.png"),
	"PointBlock":  preload("res://Sprites/Point.png")
}

var BlockText = {
	"RedBlock": "A block where you die instantly when touched, and sent straight back to the start. ",
	"BombBlock": "A block which explodes upon touched, and sends you back to the start.",
	"ShrinkBlock": "A block when upon hit shrinks you until the end of the level. Useful for getting through tight spots.",
	"EndBlock": "Going to this block ends the level, provided you've got a Point. If there's no point, go right to it.",
	"PointBlock":  "If this block is in the level, you must grab it to complete the level."
}

func _ready():
	get_node("../Player").connect("player_died", self, "update_death_display")
	get_node("../Player").connect("pause_game", self, "pause_game")
	get_node("../Player").connect("block_tutorial", self, "show_block_tutorial")
	
	# To make sure that the deaths are shown when the level is loaded
	var death = ProjectSettings.get_setting("PLAYER_DEATHS")
	update_death_display(death)
	
	$pause.hide()
	$pause.set_exclusive(true)
	
	$BlockTutorial.hide()
	$BlockTutorial.set_exclusive(false)

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

func show_block_tutorial(block_name):
	if BlockImage.has(block_name) and BlockText.has(block_name):
		$BlockTutorial/BlockText.text = BlockText[block_name]
		$BlockTutorial/BlockImage.texture = BlockImage[block_name]
		
		get_node("/root/MusicPlayer").stop_music()
		$BlockTutorial.popup()
		get_tree().set_pause(true)
	else:
		printerr("Block tutorial failed! No known block type: " + block_name)

func _on_BlockTutorial_popup_hide():
	get_tree().set_pause(false)
	get_node("/root/MusicPlayer").play_level_music()