extends Camera2D

var drag_margin_left = 0.3
var drag_margin_right = 0.7

var right_limit = 1000000
var left_limit = -1000000

var screen_size

func _ready():
	screen_size = self.get_viewport_rect().size

func update_viewport():
	var canvas_transform = self.get_viewport().canvas_transform
	canvas_transform.o = -self.get_global_transform() + screen_size / 2.0
	self.get_viewport().canvas_transform = canvas_transform
	
func update_camera(pos):
	var new_pos = get_global_transform()
	
	# Right Margin
	if pos.x > get_global_transform().x + screen_size.width * (drag_margin_right - 0.5):
		new_pos.x = pos.x - screen_size.width + (drag_margin_right - 0.5)
	
	