extends StaticBody2D

func on_player_hit():
	get_node("/root/AudioPlayer").play_sfx("SFXDecreaseSizeHit")
	queue_free()