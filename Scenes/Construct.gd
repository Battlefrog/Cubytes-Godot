extends Node

var SceneLoaded = false
var Scene = null

func _ready():
	LoadSceneIntoMe("res://Scenes/MainMenu.tscn")
	
func LoadSceneIntoMe(var ScenePath):
	
	Scene = load(ScenePath)
	get_node("LEVEL").add_child(Scene, true)
	SceneLoaded = true
