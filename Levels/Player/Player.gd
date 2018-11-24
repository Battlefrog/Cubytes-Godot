extends KinematicBody2D

signal player_died
signal pause_game

export (int) var player_speed = 750

# The EndBlock is always going to be in the level with the Player
onready var EndBlockRef = get_node("../EndBlock")
onready var PointRef = has_node("../Point")

var velocity = Vector2()
var start_position
var respawn_position
var dead

var shrunk

func _ready():
	if PointRef == false:
		EndBlockRef.point_collected = true

	start_position = get_transform()
	respawn_position = start_position
	shrunk = false
	dead = false

	# Starting as 'big' by default
	$BigSprite.visible = true
	$BigCollisionShape2D.disabled = false
	$SmallCollisionShape2D.disabled = true
	$SmallSprite.visible = false

	# Activate
	show()
	set_process(true)

func _process(delta):
	if ProjectSettings.get_setting("click_teleport"):
		var mouse_pos = get_viewport().get_mouse_position()
		if Input.is_mouse_button_pressed(BUTTON_LEFT):
			position = mouse_pos

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
	# TODO: Why is this on the player? 
	#       Make another node for UI related process events, or just use GameUI
	if Input.is_action_pressed("ui_cancel"):
		emit_signal("pause_game")

	# Getting collisions
	var collision_info = move_and_collide(velocity.normalized() * player_speed * delta)

	# Responding to certain collisions
	collision_check(collision_info)

	# Applying Movement
	position += velocity * delta

# Responding to any collisions
func collision_check(collisions):
	# If there's any collisions in the first place...
	if collisions:
		if collisions.collider.name == "EndBlock":
			collisions.collider.call("on_player_hit")
		elif collisions.collider.name == "Blocks":
			get_node("/root/AudioPlayer").play_sfx("SFXIntoWall")
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
		elif collisions.collider.name.begins_with("Flag"):
			collisions.collider.call("on_player_hit")
			change_respawn_position(collisions.collider)

# When the Player dies
func die():
	dead = true

	# Update death count
	var death = ProjectSettings.get_setting("player_deaths")
	ProjectSettings.set_setting("player_deaths", death + 1)
	death = ProjectSettings.get_setting("player_deaths")

	get_node("/root/ParticlePlayer").play_ptx("PTXPlayerDeath", get_transform())

	set_process(false)

	# Stopping player from moving
	yield(get_tree().create_timer(0.50), "timeout")

	emit_signal("player_died", death)

	get_node("/root/AudioPlayer").play_sfx("SFXPlayerRespawn")

	position = respawn_position.get_origin()

	if !shrunk:
		$BigCollisionShape2D.disabled = false
		$SmallCollisionShape2D.disabled = true
	else:
		$BigCollisionShape2D.disabled = true
		$SmallCollisionShape2D.disabled = false
	
	show()
	set_process(true)
	dead = false

func end_of_level():
	set_process(false)

func shrink():
	shrunk = true
	player_speed = 500

	$BigSprite.visible = false
	$SmallSprite.visible = true
	$BigCollisionShape2D.disabled = true
	$SmallCollisionShape2D.disabled = false

func change_respawn_position(object):
	var pos = object.get_transform()
	respawn_position = pos

func decrease_speed():
	if shrunk:
		player_speed = 300
	else:
		player_speed = 500

func normalize_speed():
	if shrunk:
		player_speed = 500
	else:
		player_speed = 750