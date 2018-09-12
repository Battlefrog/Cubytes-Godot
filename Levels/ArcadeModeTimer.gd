extends Timer

var starting_time
var ending_time

var level_time_min
var level_time_sec

func _ready():
	starting_time = OS.get_time()
	starting_time = starting_time.values()

# TODO: Games longer than an hour will break and display the wrong time
# TODO: Add ms support
# TODO: This doesn't fucking work
func on_level_complete():
	ending_time = OS.get_time()
	ending_time = ending_time.values()
	
	var s_min = starting_time[1]
	var e_min = ending_time[1]
	
	var s_sec = starting_time[2]
	var e_sec = ending_time[2]
	
	level_time_min = e_min - s_min
	level_time_sec = e_sec - s_sec
	
	print("min: " + str(level_time_min))
	print("sec: " + str(level_time_sec))
	