extends StaticBody2D

func _ready():
	$ExplosionSFX.stream.loop = false
	
func on_player_hit():	
	$ExplosionSFX.play()