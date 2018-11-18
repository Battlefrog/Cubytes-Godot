extends Node

var current_scene = null
var audio_bus = preload("res://Misc/default_bus_layout.tres")

#var GAs = load("res://GameAnalytics.gd")
#var GA = GAs.new()

func _ready():
#  GA.game_key = <your_game_key_supplied_by_GameAnalytics>
#  GA.secret_key = <your_secret_key_supplied_by_GameAnalytics>
#  GA.base_url = "http://api.gameanalytics.com"
#
#  # Run once per session
#  init_response = GA.request_init()
#
#  # Add events to queue
#  GA.add_to_event_queue(GA.get_test_design_event("player:new_level", 1))
#  GA.add_to_event_queue(GA.get_test_design_event("player:new_level", 2))
#
#  # Submit events and flush queue - return code will indicate success (200) or failure (400, 401, 404)
#  var returned = GA.submit_events()
	
	if OS.is_debug_build():
		ProjectSettings.set_setting("debug_mode", true)
		ProjectSettings.set_setting("click_teleport", true)
	else:
		ProjectSettings.set_setting("debug_mode", false)
		ProjectSettings.set_setting("click_teleport", false)
	
	AudioServer.set_bus_layout(audio_bus)
	
	# Getting the current scene
	var root = get_tree().get_root()
	current_scene = root.get_child(root.get_child_count() - 1)

func goto_scene(path):
	# Deleting the current scene at this point might be
	# a bad idea, because it may be inside of a callback or function of it.
	# The worst case will be a crash or unexpected behavior.
	
	# The way around this is deferring the load to a later time, when
	# it is ensured that no code from the current scene is running:
	 call_deferred("_deferred_goto_scene", path)

func _deferred_goto_scene(path):
	current_scene.free()
	
	 # Load new scene
	var s = ResourceLoader.load(path)
	
	current_scene = s.instance()
	
	# Add it to the active scene, as child of root
	get_tree().get_root().add_child(current_scene)
	get_tree().set_current_scene(current_scene)