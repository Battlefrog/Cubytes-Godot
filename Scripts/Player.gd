extends KinematicBody2D

signal player_died
signal pause_game

export (int) var player_speed = 750

onready var EndBlockRef = get_node("../EndBlock")

# Should be a var because point's aren't always going to be there
onready var PointRef = get_node("../Point")

var velocity = Vector2()
var start_position

var shrunk

func _ready():
	# Not the best way to do things.
	if PointRef == null:
		EndBlockRef.point_collected = true
	
	start_position = get_transform()
	shrunk = false
	
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
	
	# Pausing game
	if Input.is_action_pressed("ui_cancel"):
		emit_signal("pause_game")
	
	# Getting collisions
	var collision_info = move_and_collide(velocity.normalized() * player_speed * delta)
	
	# Responding to certain collisions
	CheckForCollisions(collision_info)
	
	# Applying Movement
	position += velocity * delta

# Responding to any collisions
func CheckForCollisions(collisions):
	# If there's any collisions in the first place...
	if collisions:
		print("Collision: ", collisions.collider.name)
		if collisions.collider.name == "EndBlock":
			collisions.collider.call("on_player_hit")
		elif collisions.collider.name == "Blocks":
			get_node("/root/SFXPlayer").play_sfx("SFXIntoWall")
			die()	
		elif collisions.collider.name == "Point":
			EndBlockRef.point_collected = true
			collisions.collider.call("on_player_hit")
		# begins_with to allow for multiple bombs
		elif collisions.collider.name.begins_with("Bomb"):
			collisions.collider.call("on_player_hit")
			die()
		elif collisions.collider.name == "DecreaseSize":
			collisions.collider.call("on_player_hit")
			shrink()

# When the Player dies
func die():
	var death = ProjectSettings.get_setting("PLAYER_DEATHS")
	ProjectSettings.set_setting("PLAYER_DEATHS", death + 1)
	death = ProjectSettings.get_setting("PLAYER_DEATHS")
	
	$PlayerDeathAnim.emitting = true
	
	set_process(false)
	
	yield(get_tree().create_timer(0.50), "timeout")
	
	emit_signal("player_died", death)
	
	get_node("/root/SFXPlayer").play_sfx("SFXPlayerRespawn")
	
	position = start_position.get_origin()
	show()
	
	if !shrunk:
		$BigCollisionShape2D.disabled = false
		$SmallCollisionShape2D.disabled = true
	else:
		$BigCollisionShape2D.disabled = true
		$SmallCollisionShape2D.disabled = false
	
	set_process(true)

# What happens to the player at the end of the level
func end_of_level():
	set_process(false)

# Shrink the Player
func shrink():
	shrunk = true
	player_speed = 500
	
	$BigSprite.visible = false
	$SmallSprite.visible = true
	$BigCollisionShape2D.disabled = true
	$SmallCollisionShape2D.disabled = false