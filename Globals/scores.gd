extends Node

var highscores = []
const NUM_ARCADE_LEVELS = 8

func _ready():
	for i in range(NUM_ARCADE_LEVELS):
		highscores.push_back(0)

func add_to_highscores(time, level):
	var level_ins = level - 1
	
	highscores[level_ins] = time
	
	# print(highscores)

func get_highscore(level):
	var level_want = level - 1
	
	return highscores[level_want]

func get_highscores():
	return highscores