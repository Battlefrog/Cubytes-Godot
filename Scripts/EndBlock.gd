# TODO: All of this is for only Story Mode. Arcade Mode will be different. Generalize this, perhaps?

extends StaticBody2D

export (String) var next_level_name
var point_collected = false

onready var PlayerRef = get_node("../Player")

# TODO: Play particle effect
func on_player_hit():
	if point_collected:
		get_node("/root/SFXPlayer").play_sfx("SFXCompleteLevel")
		PlayerRef.end_of_level()
		yield(get_tree().create_timer(1.2), "timeout")
		get_node("/root/global").goto_scene("res://Scenes/StoryLevels/" + next_level_name + ".tscn")