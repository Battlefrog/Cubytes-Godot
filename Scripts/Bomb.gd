extends Sprite

var Exploded = false

var PlayerRef

func _ready():
	PlayerRef = get_node("../Player")
	
	PlayerRef.connect("RanIntoBomb", self, "Blowup")
	$ExplosionSFX.stream.loop = false
	
func Blowup():
	if !Exploded:
		$ExplosionSFX.play()
		$Bomb/CollisionShape2D.disabled = true
		set_process(false)
		hide()
		Exploded = true