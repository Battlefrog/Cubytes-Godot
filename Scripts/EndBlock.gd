extends Sprite

var PointCollected = false
var Player

func _ready():
	# Player.connect("PointCollected", Player, "PlayerPointCollected")
	pass
	
# func PlayerPointCollected():
	# PointCollected = true

func OnPlayerEndBlockHit(LevelPath):
	# Play sound and wait
	# Maybe do some particle effects?
	get_tree().change_scene(LevelPath)
	pass
