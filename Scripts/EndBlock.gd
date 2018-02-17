extends Sprite

var PointCollected = false

func _ready():
	$CompleteLevelSFX.stream.loop = false
	
func OnPlayerEndBlockHit(LevelPath):
	if PointCollected:
		$CompleteLevelSFX.play()
		# Wait
		get_tree().change_scene(LevelPath)