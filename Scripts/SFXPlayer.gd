extends Node

# Dictionary for all SFX - Replacement for SampleLibrary in Godot 2
var SFX = {
	"SFXAccept": preload("res://Sounds/UIAccept.ogg"),
	"SFXBack": preload("res://Sounds/UIBack.ogg"),
	"SFXStartStoryMode": preload("res://Sounds/StoryModeStart.ogg")
}

func play_sfx(var fx):
	if SFX.has(fx):
		print("SFXPlayer playing '" + fx + "' currently.")
		
		# Prevent multiple sounds from playing
		$AudioStreamPlayer.stop()
		$AudioStreamPlayer.stream = null
		
		$AudioStreamPlayer.stream = SFX[fx]
		$AudioStreamPlayer.play()
	else:
		printerr(fx + " is not a correct SFX.")