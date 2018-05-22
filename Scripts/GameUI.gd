extends Node

func _ready():
	var d = ProjectSettings.get_setting("PLAYER_DEATHS")
	
	$DeathDisplay.set_text("Deaths: " + str(d))

func _process():
	var d = ProjectSettings.get_setting("PLAYER_DEATHS")
	
	$DeathDisplay.set_text("Deaths: " + str(d))
	
	print(str(d))