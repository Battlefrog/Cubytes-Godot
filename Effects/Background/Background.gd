extends Node

var settings = {
	"HIGH": 0,
	"MEDIUM": 1,
	"LOW": 2,
	"OFF": 3
}

var setting = 0

func _ready():
	$Noise.set_region_rect(Rect2(Vector2(0.0, 0.0), OS.get_window_size()))
	set_setting(setting)

func set_setting(ID):
	match ID:
		0:
			$YellowStream.set_emitting(true)
			$Cubes_BIG.set_emitting(true)
			$Cubes_BIG2.set_emitting(true)
			$Cubes_BIG3.set_emitting(true)
		1:
			$YellowStream.set_emitting(true)
			$Cubes_BIG.set_emitting(true)
			$Cubes_BIG2.set_emitting(false)
			$Cubes_BIG3.set_emitting(false)
		2:
			$YellowStream.set_emitting(true)
			$Cubes_BIG.set_emitting(false)
			$Cubes_BIG2.set_emitting(false)
			$Cubes_BIG3.set_emitting(false)
		_: # default:
			$YellowStream.set_emitting(false)
			$Cubes_BIG.set_emitting(false)
			$Cubes_BIG2.set_emitting(false)
			$Cubes_BIG3.set_emitting(false)

func get_setting():
	return setting