extends Label

func _process(delta):
	var d = ProjectSettings.get_setting("PLAYER_DEATHS")
	
	self.set_text("Deaths: " + str(d))
	
	print(str(d))