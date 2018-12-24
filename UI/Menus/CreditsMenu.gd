extends Node2D

signal done

func _ready():
	pass

func _on_anim_animation_finished(anim_name):
	emit_signal("done")