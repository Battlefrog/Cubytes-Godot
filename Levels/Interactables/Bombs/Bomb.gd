extends StaticBody2D

# TODO: Play animation
func on_player_hit():
	get_node("/root/AudioPlayer").play_sfx("SFXBombExplosion")
	get_node("/root/ParticlePlayer").play_ptx("PTXBombExplosion", get_transform())