extends Sprite

var Exploded = false

func _ready():
	$ExplosionSFX.stream.loop = false
	
func Blowup():
	if !Exploded:
		$ExplosionSFX.play()
		$Bomb/CollisionShape2D.disabled = true
		set_process(false)
		hide()
		Exploded = true