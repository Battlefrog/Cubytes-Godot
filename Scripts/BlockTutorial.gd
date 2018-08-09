extends Node2D

signal block_tutorial

export (String) var ui_name
export (String, MULTILINE) var ui_text
export (Texture) var ui_picture_path

func _ready():
	yield(get_tree().create_timer(0.05), "timeout")
	emit_signal("block_tutorial", ui_text, ui_picture_path, ui_name)