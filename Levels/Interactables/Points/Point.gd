extends StaticBody2D

signal point_hit

# TODO: Add particle effect
func on_player_hit():
	get_node("/root/AudioPlayer").play_sfx("SFXPointHit")
	emit_signal("point_hit")
	queue_free()