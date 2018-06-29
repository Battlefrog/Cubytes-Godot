extends Node

func _ready():
	play_menu_music()

func play_level_music():
	$MenuMusic.stop()
	$LevelMusic.play($LevelMusic.get_playback_position())

func play_menu_music():
	$MenuMusic.play($MenuMusic.get_playback_position())
	$LevelMusic.stop()

func stop_music():
	$MenuMusic.stop()
	$LevelMusic.stop()