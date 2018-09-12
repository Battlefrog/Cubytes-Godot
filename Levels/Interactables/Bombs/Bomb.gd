extends StaticBody2D

func on_player_hit():
	# TODO: Play animation
	get_node("/root/SFXPlayer").play_sfx("SFXBombExplosion")
	get_node("/root/ParticlePlayer").play_ptx("PTXBombExplosion", get_transform())