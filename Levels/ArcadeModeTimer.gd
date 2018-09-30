extends Timer

var starting_time
var ending_time

var level_time_min
var level_time_sec

func _ready():
	starting_time = OS.get_unix_time()

# TODO: Games longer than an hour will break and display the wrong time
# TODO: Add ms support
# TODO: This doesn't fucking work
func on_level_complete():
	ending_time = OS.get_unix_time()
	
	var finished_unix_time = ending_time - starting_time
	
	print("Ending Unix Time: " + str(finished_unix_time))