extends Node2D

func _on_StoryModeButton_pressed():
	get_tree().change_scene("res://Scenes/StoryLevels/Level1.tscn")


func _on_BackButton_pressed():
	get_tree().change_scene("res://Scenes/MainMenu.tscn")
