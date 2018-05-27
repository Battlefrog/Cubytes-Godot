extends StaticBody2D

var collected = false

func _ready():
	$PointHitSFX.stream.loop = false

func on_player_hit():
	if !collected:
		$PointHitSFX.play()
		$CollisionShape2D.disabled = true
		set_process(false)
		hide()
		collected = true