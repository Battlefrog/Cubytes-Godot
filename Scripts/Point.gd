extends StaticBody2D

var Collected = false

func _ready():
	$PointHitSFX.stream.loop = false

func PlayerPointCollected():
	if !Collected:
		$PointHitSFX.play()
		$CollisionShape2D.disabled = true
		set_process(false)
		hide()
		Collected = true