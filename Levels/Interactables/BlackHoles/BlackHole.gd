extends Area2D

func _ready():
	$AudioStreamPlayer2D.set_bus("SFX")
	$Sprite2.rotation = rand_range(0.0, 360.0)

func _process(delta):
	if $Sprite2.rotation <= 360:
		$Sprite2.rotation = $Sprite2.rotation + (rand_range(24.0, 27.0) * delta)
	else:
		$Sprite2.rotation = 0

func _on_BlackHole_entered(body):
	if body.is_in_group("Player"):
		body.call("decrease_speed")
		$Timer.start()
		$AudioStreamPlayer2D.play()

func _on_BlackHole_exited(body):
	if body.is_in_group("Player"):
		body.call("normalize_speed")
		$Timer.stop()
		fade_out($AudioStreamPlayer2D)

func _on_Timer_timeout():
	for body in get_overlapping_bodies():
		if body.is_in_group("Player"):
			kill_player(body)

func _on_Area2D_entered(body):
	if body.is_in_group("Player"):
		kill_player(body)

func kill_player(player):
	if not player.dead:
		$Timer.stop()
		player.call("die")
		get_node("/root/AudioPlayer").play_sfx("SFXShooterShoot")
		fade_out($AudioStreamPlayer2D)

# Fade out SFX
func fade_out(stream):
	$Tween.interpolate_property(stream, "volume_db", 0, -80, 0.1, Tween.TRANS_QUAD, Tween.EASE_IN, 0)
	$Tween.start()

func _on_Tween_completed(object, key):
	$Tween.stop(object, key)
	$AudioStreamPlayer2D.set_volume_db(0.0)