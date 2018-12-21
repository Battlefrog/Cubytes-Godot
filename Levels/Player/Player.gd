extends KinematicBody2D

signal player_died

const MOVE_FORCE_BIG = 700
const MOVE_FORCE_SML = 400
const STOP_FORCE = 1750
const MOVE_MAX_SPEED_BIG = 750
const MOVE_MAX_SPEED_SML = 450

onready var EndBlockRef = get_node("../EndBlock")
onready var GameUIRef = get_node("../GameUI")
onready var PointRef = has_node("../Point")

var velocity = Vector2()
var min_speed = 50
var max_speed
var move_force
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
	move_force = MOVE_FORCE_BIG
	max_speed = MOVE_MAX_SPEED_BIG
	
	# Activate
	show()
	set_process(true)

func _process(delta):
	if ProjectSettings.get_setting("click_teleport") and not EndBlockRef.is_arcade_mode():
		var mouse_pos = get_viewport().get_mouse_position()
		if Input.is_mouse_button_pressed(BUTTON_LEFT):
			position = mouse_pos
	
	velocity = Vector2()
	
	var force = Vector2(0, 0)
	var stop = true
	var vstop = true
	
	# Detecting Movement
	if Input.is_action_pressed("ui_left"):
		if velocity.x <= min_speed and velocity.x > -max_speed:
			force.x -= move_force
			stop = false
	if Input.is_action_pressed("ui_right"):
		if velocity.x >= -min_speed and velocity.x < max_speed:
			force.x += move_force
			stop = false
	if Input.is_action_pressed("ui_down"):
		if velocity.y >= -min_speed and velocity.y < max_speed:
			force.y += move_force
			vstop = false
	if Input.is_action_pressed("ui_up"):
		if velocity.y <= min_speed and velocity.y > -max_speed:
			force.y -= move_force
			vstop = false
	
	if stop:
		var vsign = sign(velocity.x)
		var vlen = abs(velocity.x)
		
		vlen -= STOP_FORCE * delta
		if vlen < 0:
			vlen = 0
		
		velocity.x = vlen * vsign
	
	if vstop:
		var vsign = sign(velocity.y)
		var vlen = abs(velocity.y)
		
		vlen -= STOP_FORCE * delta
		if vlen < 0:
			vlen = 0
		
		velocity.y = vlen * vsign
	
	velocity += force * delta
	
	# Collisions
	var collision_info = move_and_collide(velocity)
	collision_check(collision_info)
	
	# Applying Movement
	position += velocity.normalized() * delta

# Responding to any collisions
func collision_check(collisions):
	# If there's any collisions in the first place...
	if collisions:
		if collisions.collider.name == "EndBlock":
			collisions.collider.call("on_player_hit")
		elif collisions.collider.name == "Blocks":
			get_node("/root/AudioPlayer").play_sfx("SFXIntoWall")
			GameUIRef.shake(0.15, 15, 8, 0)
			die()
		elif collisions.collider.name == "Point":
			EndBlockRef.point_collected = true
			collisions.collider.call("on_player_hit")
		# begins_with to allow for multiple bombs
		elif collisions.collider.name.begins_with("Bomb"):
			GameUIRef.shake(0.15, 15, 8, 0)
			collisions.collider.call("on_player_hit")
			die()
		elif collisions.collider.name == "DecreaseSize":
			collisions.collider.call("on_player_hit")
			shrink()
		elif collisions.collider.name.begins_with("Flag"):
			collisions.collider.call("on_player_hit")
			change_respawn_position(collisions.collider)

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
	max_speed = MOVE_MAX_SPEED_SML
	move_force = MOVE_FORCE_SML
	
	$BigSprite.visible = false
	$SmallSprite.visible = true
	$BigCollisionShape2D.disabled = true
	$SmallCollisionShape2D.disabled = false

func change_respawn_position(object):
	var pos = object.get_transform()
	respawn_position = pos

func decrease_speed():
	if shrunk:
		max_speed = 300
	else:
		max_speed = 500

func normalize_speed():
	if shrunk:
		max_speed = MOVE_MAX_SPEED_SML
	else:
		max_speed = MOVE_MAX_SPEED_BIG