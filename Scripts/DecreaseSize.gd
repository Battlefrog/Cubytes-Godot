extends StaticBody2D

var Collected = false

func _ready():
	$ShrinkSFX.stream.loop = false

func Shrink():
	if !Collected:
		$ShrinkSFX.play()
		$CollisionShape2D.disabled = true
		set_process(false)
		hide()
		Collected = true