extends StaticBody2D

var collected = false

# TODO: Add particle effect
func on_player_hit():
	if !collected:
		$PointHitSFX.play()
		$CollisionShape2D.disabled = true
		set_process(false)
		hide()
		collected = true