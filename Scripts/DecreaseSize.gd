extends StaticBody2D

func on_player_hit():
	get_node("/root/SFXPlayer").play_sfx("SFXDecreaseSize")
	queue_free()