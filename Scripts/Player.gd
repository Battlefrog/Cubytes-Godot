extends KinematicBody2D

signal player_died

export (int) var player_speed = 750

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
	
	set_process(false)
	
	# Little bit of a breather before anything happens.
	yield(get_tree().create_timer(0.40), "timeout")
	
	emit_signal("player_died", death)
	
	$RespawnSFX.play()
	
	position = start_position.get_origin()
	show()
	$BigCollisionShape2D.disabled = false
	$SmallCollisionShape2D.disabled = true
	set_process(true)

func restart():
	$RespawnSFX.play()
	get_tree().reload_current_scene()
	
func end_of_level():
	set_process(false)
	
func shrink():
	shrunk = true
	player_speed = 500
	
	$BigSprite.visible = false
	$SmallSprite.visible = true
	$BigCollisionShape2D.disabled = true
	$SmallCollisionShape2D.disabled = false
	
func grow():
	shrunk = false
	player_speed = 750
	
	$BigSprite.visible = true
	$SmallSprite.visible = false
	$BigCollisionShape2D.disabled = false
	$SmallCollisionShape2D.disabled = true