extends KinematicBody2D

export (int) var PlayerSpeed

# Okay so after failing for about an hour this is 
# how to get a node at your hierarchial level.
onready var EndBlockRef = get_node("../EndBlock")

var Velocity = Vector2()
var ScreenSize
var StartPos

func _ready():
	StartPos = get_transform()
	ScreenSize = get_viewport_rect().size

func _process(delta):
	Velocity = Vector2()
	
	# Detecting Movement
	if Input.is_action_pressed("ui_right"):
		Velocity.x += 1
	if Input.is_action_pressed("ui_left"):
		Velocity.x -= 1
	if Input.is_action_pressed("ui_up"):
		Velocity.y -= 1
	if Input.is_action_pressed("ui_down"):
		Velocity.y += 1
	
	# Applying Movement
	var collision_info = move_and_collide(Velocity.normalized() * PlayerSpeed * delta)
	
	# Checking for certain collisions
	if collision_info:
		print("Collision: ", collision_info.collider.name)
		if collision_info.collider.name == "EndBlock":
			EndBlockRef.OnPlayerEndBlockHit("res://MainMenu.tscn")
		elif collision_info.collider.name == "Blocks":
			restart()
		
	# Stop the player from going off the screen
	position += Velocity * delta
	position.x = clamp(position.x, 0, ScreenSize.x)
	position.y = clamp(position.y, 0, ScreenSize.y)
	
func restart():
	# This is the correct way to get the X and Y coords. At least I think
	position = StartPos.get_origin()
	show()
	$CollisionShape2D.disabled = false