extends Label

func _process(delta):
	
	#TODO: Dumb to do this every frame.
	var d = ProjectSettings.get_setting("PLAYER_DEATHS")
	
	self.set_text("Deaths: " + str(d))
	
	# print(str(d))