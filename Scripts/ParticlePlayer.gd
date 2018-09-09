extends Node

var PTX = {
	"PTXPlayerDeath": preload("res://Scenes/PlayerDeathAnim.tscn"),
	"PTXExplosion": preload("res://Scenes/BombExplosion.tscn"),
	"PTXEndBlockEnding": preload("res://Scenes/EndBlockEnding.tscn")
}

func _process(delta):
	for child in get_children():
		if child.is_class("Particles2D"):
			if !child.is_emitting():
				child.free()

func play_ptx(var ptx, pos):
	if PTX.has(ptx):
		var ptx_instance = PTX[ptx].instance()
		ptx_instance.set_name(str(PTX[ptx]))
		ptx_instance.set_position(pos.get_origin())
		ptx_instance.set_emitting(true)
		add_child(ptx_instance)
		print("ParticlePlayer now playing '" + ptx + "' currently.")
	else:
		printerr(ptx + "is not a correct PTX.")