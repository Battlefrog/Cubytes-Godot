extends KinematicBody2D

signal player_died

export (int) var player_speed = 750

# Okay so after failing for about an hour this is 
# how to get a node at your hierarchial level.
onready var EndBlockRef = get_node("../EndBlock")
onready var PointRef = get_node("../Point")

var velocity = Vector2()
var start_position

var shrunk

func _ready():
	if PointRef == null:
		EndBlockRef.point_collected = true
	
	start_position = get_transform()
	shrunk = false
	
	$WallHitSFX.stream.loop = false
	$RespawnSFX.stream.loop = false
	$BigSprite.visible = true
	$BigCollisionShape2D.disabled = false
	$SmallCollisionShape2D.disabled = true
	$SmallSprite.visible = false
	
	show()
	set_process(true)
	
func _process(delta):
	velocity = Vector2()
	
	# Detecting Movement
	if Input.is_action_pressed("ui_right"):
		velocity.x += 1
	if Input.is_action_pressed("ui_left"):
		velocity.x -= 1
	if Input.is_action_pressed("ui_up"):
		velocity.y -= 1
	if Input.is_action_pressed("ui_down"):
		velocity.y += 1
	
	# Applying Movement
	var collision_info = move_and_collide(velocity.normalized() * player_speed * delta)
	
	# Checking for certain collisions
	CheckForCollisions(collision_info)
		
	position += velocity * delta
	
func CheckForCollisions(collisions):
	# If there's any collisions in the first place...
	if collisions:
		print("Collision: ", collisions.collider.name)
		if collisions.collider.name == "EndBlock":
			collisions.collider.call("on_player_hit")
		elif collisions.collider.name == "Blocks":
			$WallHitSFX.play()
			die()	
		elif collisions.collider.name == "Point":
			EndBlockRef.point_collected = true
			collisions.collider.call("on_player_hit")
		# begins_with to allow for multiple bombs
		elif collisions.collider.name.begins_with("Bomb"):
			collisions.collider.call("on_player_hit")
			die()
		elif collisions.collider.name.begins_with("DecreaseSize"):
			collisions.collider.call("on_player_hit")
			shrink()
	
func die():
	var death = ProjectSettings.get_setting("PLAYER_DEATHS")
	ProjectSettings.set_setting("PLAYER_DEATHS", death + 1)
	death = ProjectSettings.get_setting("PLAYER_DEATHS")
	
	emit_signal("player_died", death)
	
	# TODO: Maybe play a particle effect or something?
	$RespawnSFX.play()
	
	# This is the correct way to get the X and Y coords. At least I think
	position = start_position.get_origin()
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
	shrunk = true
	player_speed = 600
	
	$BigSprite.visible = false
	$SmallSprite.visible = true
	$BigCollisionShape2D.disabled = false
	$SmallCollisionShape2D.disabled = true
	
func grow():
	shrunk = false
	player_speed = 750
	
	$BigSprite.visible = true
	$SmallSprite.visible = false
	$BigCollisionShape2D.disabled = true
	$SmallCollisionShape2D.disabled = false