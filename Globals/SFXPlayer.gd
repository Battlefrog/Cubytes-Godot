extends Node

# Dictionary for all SFX - Replacement for SampleLibrary in Godot 2
var SFX = {
	"SFXAccept": preload("res://UI/Menus/UIAccept.ogg"),
	"SFXBack": preload("res://UI/Menus/UIBack.ogg"),
	"SFXStartStoryMode": preload("res://UI/Menus/StartStoryMode.ogg"),
	"SFXBombExplosion": preload("res://Levels/Interactables/Bombs/BombExplosion.ogg"),
	"SFXIntoWall": preload("res://Levels/IntoWall.ogg"),
	"SFXPlayerRespawn": preload("res://Levels/Player/PlayerSpawn.ogg"),
	"SFXPointHit": preload("res://Levels/Interactables/Points/PointHit.ogg"),
	"SFXDecreaseSizeHit": preload("res://Levels/Interactables/DecreaseSize/DecreaseSizeHit.ogg"),
	"SFXEndBlockCompleteLevel": preload("res://Levels/Interactables/EndBlock/EndBlockCompleteLevel.ogg"),
	"SFXShooterShoot": preload("res://Levels/Interactables/Shooters/ShooterShoot.ogg"),
	"SFXEndBlockRefusal": preload("res://Levels/Interactables/EndBlock/EndBlockRefusal.ogg"),
	"SFXFlagHit": preload("res://Levels/Interactables/Flags/FlagHit.ogg")
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