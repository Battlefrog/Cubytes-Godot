extends StaticBody2D

func on_player_hit():
	# TODO: Play animation
	get_node("/root/SFXPlayer").play_sfx("SFXExplosion")
	get_node("/root/ParticlePlayer").play_ptx("PTXExplosion", get_transform())