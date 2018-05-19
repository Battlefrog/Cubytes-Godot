extends Node2D

func _on_MainMenuButton_pressed():
	get_node("/root/global").goto_scene("res://Scenes/MainMenu.tscn")
