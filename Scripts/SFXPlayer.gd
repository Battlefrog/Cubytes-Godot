extends Node

# Dictionary for all SFX - Replacement for SampleLibrary in Godot 2
var SFX = {
	"SFXAccept": preload("res://Sounds/UIAccept.ogg"),
	"SFXBack": preload("res://Sounds/UIBack.ogg"),
	"SFXStartStoryMode": preload("res://Sounds/StoryModeStart.ogg"),
	"SFXExplosion": preload("res://Sounds/explosion.ogg"),
	"SFXIntoWall": preload("res://Sounds/intoWall.ogg"),
	"SFXPlayerRespawn": preload("res://Sounds/playerRespawn.ogg"),
	"SFXPointPickup": preload("res://Sounds/pointPickup.ogg"),
	"SFXDecreaseSize": preload("res://Sounds/DecreaseSizeHit.ogg"),
	"SFXCompleteLevel": preload("res://Sounds/completeLevel.ogg"),
	"SFXShooterShoot": preload("res://Sounds/ShooterShoot.ogg"),
	"SFXEndBlockRefusal": preload("res://Sounds/EndBlockRefusal.ogg"),
	"SFXFlagHit": preload("res://Sounds/FlagHit.ogg")
}

func play_sfx(var fx):
	if SFX.has(fx):
		print("SFXPlayer playing '" + fx + "' currently.")
		
		# Stop current playing sounds
		$AudioStreamPlayer.stop()
		$AudioStreamPlayer.stream = null
		
		$AudioStreamPlayer.stream = SFX[fx]
		$AudioStreamPlayer.play()
	else:
		printerr(fx + " is not a correct SFX.")

func playing_sfx(var fx):
	if SFX.has(fx):
		return ($AudioStreamPlayer.stream == SFX[fx] and $AudioStreamPlayer.is_playing())