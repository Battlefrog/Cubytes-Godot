extends StaticBody2D

var Exploded = false

func _ready():
	$ExplosionSFX.stream.loop = false
	
func Blowup():
	if !Exploded:
		$ExplosionSFX.play()
		$Sprite.hide()
		Exploded = true
		$CollisionShape2D.set_disabled(true)