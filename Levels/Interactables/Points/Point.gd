extends StaticBody2D

# TODO: Add particle effect
func on_player_hit():
	get_node("/root/SFXPlayer").play_sfx("SFXPointHit")
	queue_free()