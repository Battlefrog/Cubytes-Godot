extends StaticBody2D

export (String) var NextLevelName
var PointCollected = false

onready var PlayerRef = get_node("../Player")

func _ready():
	$CompleteLevelSFX.stream.loop = false
	
func OnPlayerEndBlockHit():
	if PointCollected:
		$CompleteLevelSFX.play()
		PlayerRef.end_of_level()
		yield(get_tree().create_timer(0.5), "timeout")
		get_node("/root/global").goto_scene("res://Scenes/StoryLevels/" + NextLevelName + ".tscn")