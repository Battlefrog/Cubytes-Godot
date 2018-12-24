extends Control

func _ready():
	$MainMenuButton.set_process(false)
	$MainMenuButton.hide()
	
	$Credits.connect("done", self, "credits_done")

func _on_MainMenuButton_pressed():
	get_node("/root/AudioPlayer").play_sfx("SFXBack")
	get_node("/root/AudioPlayer").play_menu_music()
	get_node("/root/global").goto_scene("res://UI/Menus/MainMenu.tscn")

func credits_done():
	$MainMenuButton.set_process(true)
	$MainMenuButton.show()