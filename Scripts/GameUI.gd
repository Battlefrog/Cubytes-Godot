extends Node

export (int) var CurrentLevelNum

func _process(delta):
	
	#TODO: Dumb to do this every frame.
	var d = ProjectSettings.get_setting("PLAYER_DEATHS")
	
	$DeathDisplay.set_text("Deaths: " + str(d))
	$LevelDisplay.set_text("Level: " + str(CurrentLevelNum))