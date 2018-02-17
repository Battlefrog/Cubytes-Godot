extends Sprite

func _ready():
	$PointHitSFX.stream.loop = false

func PlayerPointCollected():
	$PointHitSFX.play()
	queue_free()