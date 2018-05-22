extends StaticBody2D

var Exploded = false

func _ready():
	$ExplosionSFX.stream.loop = false
	
func Blowup():	
	$ExplosionSFX.play()