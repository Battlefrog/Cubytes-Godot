extends Node

export (int) var CurrentLevelNum

func _ready():
	get_node("../Player").connect("player_death", self, "update_death_display")
	
func _process(delta):
	print(Performance.get_monitor(Performance.TIME_FPS))
	print(Engine.is_editor_hint())
	
	$LevelDisplay.set_text("Level: " + str(CurrentLevelNum))
	
	$FPSDisplay.set_text("FPS: " + str(Performance.get_monitor(Performance.TIME_FPS)))
	
func update_death_display(death):
	$DeathDisplay.set_text("Deaths: " + str(death))