extends KinematicBody2D

signal PointCollected

export (int) var PlayerSpeed

# Okay so after failing for about an hour this is 
# how to get a node at your hierarchial level.
onready var EndBlockRef = get_node("../EndBlock")
onready var PointRef = get_node("../Point")

var Velocity = Vector2()
var ScreenSize
var StartPos

func _ready():
	# null = NOT in the scene
	if PointRef == null:
		EndBlockRef.PointCollected = true
	
	StartPos = get_transform()
	ScreenSize = get_viewport_rect().size
	
	$WallHitSFX.stream.loop = false
	$RespawnSFX.stream.loop = false
	
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
	CheckForCollisions(collision_info)
		
	# Stop the player from going off the screen
	position += Velocity * delta
	position.x = clamp(position.x, 0, ScreenSize.x)
	position.y = clamp(position.y, 0, ScreenSize.y)
	
func CheckForCollisions(collisions):
	if collisions:
		print("Collision: ", collisions.collider.name)
		if collisions.collider.name == "EndBlock":
			EndBlockRef.OnPlayerEndBlockHit("res://Scenes/MainMenu.tscn")
		elif collisions.collider.name == "Blocks":
			$WallHitSFX.play()
			restart()
		elif collisions.collider.name == "Point":
			EndBlockRef.PointCollected = true
			PointRef.PlayerPointCollected()
	
func restart():
	$RespawnSFX.play()
	# This is the correct way to get the X and Y coords. At least I think
	position = StartPos.get_origin()
	show()
	$CollisionShape2D.disabled = false
	
func Wait(sec):
	var t = Timer.new()
	t.set_wait_time(sec)
	t.set_one_shot(true)
	self.add_child(t)
	t.start()
	yield(t, "timeout")
	t.queue_free()
	pass