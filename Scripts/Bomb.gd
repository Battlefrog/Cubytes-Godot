extends StaticBody2D

var exploded = false

func _ready():
	$ExplosionSFX.stream.loop = false

func on_player_hit():
	# TODO: Play particles and animation
	$ExplosionSFX.play()