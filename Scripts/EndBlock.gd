extends StaticBody2D

export (String) var next_level_name
export (bool) var arcade_mode

var point_collected = false

onready var PlayerRef = get_node("../Player")
onready var ArcadeTimerRef = has_node("../ArcadeModeTimer")

func _ready():
	if arcade_mode:
		ProjectSettings.set_setting("ARCADE_MODE", true)
	
	if ArcadeTimerRef:
		ArcadeTimerRef = get_node("../ArcadeModeTimer")

# TODO: Play particle effect
func on_player_hit():
	if point_collected and not arcade_mode:
		PlayerRef.end_of_level()
		get_node("/root/SFXPlayer").play_sfx("SFXCompleteLevel")
		get_node("/root/ParticlePlayer").play_ptx("PTXEndBlockEnding", get_transform())
		yield(get_tree().create_timer(1.2), "timeout")
		get_node("/root/global").goto_scene("res://Scenes/StoryLevels/" + next_level_name + ".tscn")
	elif point_collected and arcade_mode:
		ArcadeTimerRef.call("on_level_complete")
		PlayerRef.end_of_level()
		get_node("/root/SFXPlayer").play_sfx("SFXCompleteLevel")
		get_node("/root/ParticlePlayer").play_ptx("PTXEndBlockEnding", get_transform())
		yield(get_tree().create_timer(1.2), "timeout")
		get_node("/root/global").goto_scene("res://Scenes/ArcadeMode.tscn")
	else:
		if get_node("/root/SFXPlayer").playing_sfx("SFXEndBlockRefusal"):
			return
		else:
			get_node("/root/SFXPlayer").play_sfx("SFXEndBlockRefusal")