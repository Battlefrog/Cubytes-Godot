extends StaticBody2D

func on_player_hit():
	# TODO: Play particles and animation
	get_node("/root/SFXPlayer").play_sfx("SFXExplosion")