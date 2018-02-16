extends Sprite

func _ready():
	Player.connect("PointCollected", Player, "PlayerPointCollected")

func PlayerPointCollected():
	# Play sound
	
	# RIP
	queue_free()
