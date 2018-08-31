extends Area2D

func _ready():
	pass

func _on_BlackHole_entered(body):
	if body.is_in_group("Player"):
		body.call("decrease_speed")
		$Timer.start()
		$AudioStreamPlayer2D.play()

func _on_BlackHole_exited(body):
	if body.is_in_group("Player"):
		body.call("normalize_speed")
		$Timer.stop()
		$AudioStreamPlayer2D.stop()

func _on_Timer_timeout():
	for body in get_overlapping_bodies():
		if body.is_in_group("Player"):
			$Timer.stop()
			body.call("die")
			get_node("/root/SFXPlayer").play_sfx("SFXShooterShoot")
			$AudioStreamPlayer2D.stop()
