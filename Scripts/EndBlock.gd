extends StaticBody2D

export (String) var NextLevelName
var PointCollected = false

func _ready():
	$CompleteLevelSFX.stream.loop = false
	
func OnPlayerEndBlockHit():
	if PointCollected:
		$CompleteLevelSFX.play()
		# Wait
		get_tree().change_scene("res://Scenes/StoryLevels/" + NextLevelName + ".tscn")