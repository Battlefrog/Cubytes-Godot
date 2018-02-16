extends Sprite

func OnPlayerEndBlockHit(LevelPath):
	# Play sound and wait
	# Maybe do some particle effects?
	get_tree().change_scene(LevelPath)
	pass
