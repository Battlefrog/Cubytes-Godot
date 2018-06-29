extends Node

var SFX = {
	"SFXAccept": preload("res://Sounds/UIAccept.ogg"),
	"SFXBack": preload("res://Sounds/UIBack.ogg"),
	"SFXStartStoryMode": preload("res://Sounds/StoryModeStart.ogg")
}

func play_sfx(var fx):
	if SFX.has(fx):
		$AudioStreamPlayer.stream = null
		$AudioStreamPlayer.stream = SFX[fx]
		$AudioStreamPlayer.play()