extends KinematicBody2D

signal player_death	

export (int) var PlayerSpeed

# Okay so after failing for about an hour this is 
# how to get a node at your hierarchial level.
onready var EndBlockRef = get_node("../EndBlock")
onready var PointRef = get_node("../Point")

var Velocity = Vector2()
var ScreenSize
var StartPos

var Shrunk

func _ready():
	# null = NOT in the scene
	if PointRef == null:
		EndBlockRef.PointCollected = true
	
	StartPos = get_transform()
	ScreenSize = get_viewport_rect().size
	Shrunk = false
	
	$WallHitSFX.stream.loop = false
	$RespawnSFX.stream.loop = false
	$BigSprite.visible = true
	$BigCollisionShape2D.disabled = false
	$SmallCollisionShape2D.disabled = true
	$SmallSprite.visible = false
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
		elif collisions.collider.name.begins_with("DecreaseSize"):
			collisions.collider.call("Shrink")
			shrink()
	
func die():
	var death = ProjectSettings.get_setting("PLAYER_DEATHS")
	ProjectSettings.set_setting("PLAYER_DEATHS", death + 1)
	death = ProjectSettings.get_setting("PLAYER_DEATHS")
	
	emit_signal("player_death", death)
	
	# TODO: Maybe play a particle effect or something?
	$RespawnSFX.play()
	
	# This is the correct way to get the X and Y coords. At least I think
	position = StartPos.get_origin()
	show()
	$BigCollisionShape2D.disabled = false
	$SmallCollisionShape2D.disabled = true

# I'll have to think about bombs and if they should restart the level...
func restart():
	$RespawnSFX.play()
	get_tree().reload_current_scene()
	
func end_of_level():
	set_process(false)
	
func shrink():
	Shrunk = true
	PlayerSpeed = 600
	
	$BigSprite.visible = false
	$SmallSprite.visible = true
	$BigCollisionShape2D.disabled = false
	$SmallCollisionShape2D.disabled = true
	
func grow():
	Shrunk = false
	PlayerSpeed = 750
	
	$BigSprite.visible = true
	$SmallSprite.visible = false
	$BigCollisionShape2D.disabled = true
	$SmallCollisionShape2D.disabled = false