extends KinematicBody2D

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
	$CollisionShape2D.disabled = false
	show()
	set_process(true)
	
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
		
	position += Velocity * delta
	
func CheckForCollisions(collisions):
	# If there's any collisions in the first place...
	if collisions:
		print("Collision: ", collisions.collider.name)
		if collisions.collider.name == "EndBlock":
			collisions.collider.call("OnPlayerEndBlockHit")
		elif collisions.collider.name == "Blocks":
			$WallHitSFX.play()
			die()	
		elif collisions.collider.name == "Point":
			EndBlockRef.PointCollected = true
			collisions.collider.call("PlayerPointCollected")
		# begins_with to allow for multiple bombs
		elif collisions.collider.name.begins_with("Bomb"):
			collisions.collider.call("Blowup")
			die()
	
func die():
	var death = ProjectSettings.get_setting("PLAYER_DEATHS")
	ProjectSettings.set_setting("PLAYER_DEATHS", death + 1)
	
	# TODO: Maybe play a particle effect or something?
	$RespawnSFX.play()
	
	# This is the correct way to get the X and Y coords. At least I think
	position = StartPos.get_origin()
	show()
	$CollisionShape2D.disabled = false

# I'll have to think about bombs and if they should restart the level...
func restart():
	$RespawnSFX.play()
	get_tree().reload_current_scene()
	
func end_of_level():
	set_process(false)