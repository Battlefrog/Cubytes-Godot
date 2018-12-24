extends StaticBody2D

const DIRECTIONS = {Left = 0, Right = 1, Up = 2, Down = 3}
const SEGMENT_LENGTH = 16

onready var PlayerRef = get_node("../Player")

export(DIRECTIONS) var laser_direction
export(int) var laser_length
export(bool) var timed_laser
export(float) var timed_laser_time

var att_scale = 40.8
var x_offset = 0
var y_offset = 0
var x_change = 0
var y_change = 0
var laser_on = true
var collision_shape_id
var collision_a
var seg_shape

func _ready():
	get_node("../GameUI").connect("game_unpaused", self, "not_paused")
	get_node("../GameUI").connect("game_paused", self, "paused")
	
	if timed_laser == true:
		$Laser.set_gradient(preload("res://Levels/Interactables/Laser/TimedLaserGradient.tres"))
		$Sprite.set_texture(preload("res://Levels/Interactables/Laser/TimedLaser.png"))
		$TimedTimer.set_wait_time(timed_laser_time)
	
	# Setting offset based on direction
	if laser_direction == DIRECTIONS.Left:
		x_offset = -SEGMENT_LENGTH
		$Sprite.rotation = deg2rad(90)
	elif laser_direction == DIRECTIONS.Right:
		x_offset = SEGMENT_LENGTH
		$Sprite.rotation = deg2rad(270)
	elif laser_direction == DIRECTIONS.Up:
		y_offset = -SEGMENT_LENGTH
		$Sprite.rotation = deg2rad(180)
	elif laser_direction == DIRECTIONS.Down:
		y_offset = SEGMENT_LENGTH
	
	# Setting points based on offset and laser length
	for i in range(laser_length):
		$Laser.add_point(Vector2(x_offset * i, y_offset * i))
		x_change += x_offset
		y_change += y_offset
	
	add_collision()
	
	var xx = seg_shape.get_a().x
	var yy = seg_shape.get_a().y
	var cutoff = SEGMENT_LENGTH / 1.3
	
	# Finetuning the collision shape
	if (x_change != 0): # Horizontal
		if (x_change < 0): # Left
			xx += cutoff
		elif (x_change > 0): # Right
			xx -= cutoff
	elif (y_change != 0): # Vertical
		if (y_change < 0): # Up
			yy += cutoff
		elif (y_change > 0): # Down
			yy -= cutoff
	
	seg_shape.set_a(Vector2(xx, yy))
	collision_a = seg_shape.get_a()
	
	var audio_x = (get_position().x + collision_a.x) / 2
	var audio_y = (get_position().y + collision_a.y) / 2
	
	$AudioStreamPlayer2D.set_position(Vector2(audio_x, audio_y))
	$AudioStreamPlayer2D.set_bus("SFX")
	$AudioStreamPlayer2D.play()

func _process(delta):
	var distance = PlayerRef.position.distance_to(self.position)
	$AudioStreamPlayer2D.set_attenuation(distance / att_scale)

func _on_body_entered(body):
	if body.is_in_group("Player"):
		kill_player(body)

func kill_player(player):
	if not player.dead:
		player.call("die")
		get_node("/root/AudioPlayer").play_sfx("SFXShooterShoot")

func _on_timeout():
	if timed_laser:
		laser_on = !laser_on
		
		if laser_on:
			$Laser.set_visible(true)
			$LaserCollision.shape_owner_set_disabled(collision_shape_id, false)
			if not $AudioStreamPlayer2D.is_playing():
				$AudioStreamPlayer2D.play()
		else:
			$Laser.set_visible(false)
			$LaserCollision.shape_owner_set_disabled(collision_shape_id, true)
			$AudioStreamPlayer2D.stop()
		
		$TimedTimer.stop()
		$TimedTimer.start()

func add_collision():
	seg_shape = SegmentShape2D.new()
	seg_shape.set_a(Vector2(self.x_change, self.y_change))
	seg_shape.set_b(Vector2(0, 0))
	
	collision_a = to_global(seg_shape.get_a())
	
	collision_shape_id = $LaserCollision.create_shape_owner(self)
	$LaserCollision.shape_owner_add_shape(collision_shape_id, seg_shape)

func not_paused():
	$AudioStreamPlayer2D.play()

func paused():
	$AudioStreamPlayer2D.stop()