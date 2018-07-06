extends StaticBody2D

export (String) var next_level_name
export (bool) var arcade_mode

var point_collected = false

onready var PlayerRef = get_node("../Player")

# TODO: Play particle effect
func on_player_hit():
	if point_collected and not arcade_mode:
		get_node("/root/SFXPlayer").play_sfx("SFXCompleteLevel")
		PlayerRef.end_of_level()
		yield(get_tree().create_timer(1.2), "timeout")
		get_node("/root/global").goto_scene("res://Scenes/StoryLevels/" + next_level_name + ".tscn")
	elif point_collected and arcade_mode:
		get_node("/root/SFXPlayer").play_sfx("SFXCompleteLevel")
		PlayerRef.end_of_level()
		yield(get_tree().create_timer(1.2), "timeout")
		# log_highscore(time)
		get_node("/root/global").goto_scene("res://Scenes/ArcadeMode.tscn")
	else:
		if get_node("/root/SFXPlayer").playing_sfx("SFXEndBlockRefusal"):
			return
		else:
			get_node("/root/SFXPlayer").play_sfx("SFXEndBlockRefusal")