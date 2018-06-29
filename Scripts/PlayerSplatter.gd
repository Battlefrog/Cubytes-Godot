extends Sprite

export (bool) var is_shrunk = false

var player_big = preload("res://Sprites/PlayerDead.png")
var player_small = preload("res://Sprites/PlayerSmallDead.png")

func is_shrunk(value):
	is_shrunk = value

func set_sprite():
	if is_shrunk:
		$splatter.set_texture(player_small)
	else:
		$splatter.set_texture(player_big)