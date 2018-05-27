extends Node

export (int) var current_level_num

func _ready():
	get_node("../Player").connect("player_died", self, "update_death_display")
	
func _process(delta):
	$LevelDisplay.set_text("Level: " + str(current_level_num))
	
	$FPSDisplay.set_text("FPS: " + str(Performance.get_monitor(Performance.TIME_FPS)))
	
func update_death_display(death):
	$DeathDisplay.set_text("Deaths: " + str(death))