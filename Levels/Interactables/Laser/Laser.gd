extends StaticBody2D

const DIRECTIONS = {Left = 0, Right = 1, Up = 2, Down = 3}
const SEGMENT_LENGTH = 16

export(DIRECTIONS) var laser_direction
export(int) var laser_length
export(bool) var timed_laser
export(float) var timed_laser_time

var x_offset = 0
var y_offset = 0
var x_change = 0
var y_change = 0

var laser_on = true

var collision_shape

func _ready():
	if timed_laser == true:
		$Laser.set_gradient(preload("res://Levels/Interactables/Laser/TimedLaserGradient.tres"))
		$Sprite.set_texture(preload("res://Levels/Interactables/Laser/TimedLaser.png"))
		$TimedTimer.set_wait_time(timed_laser_time)
	
	# Setting offset based on direction
	if laser_direction == DIRECTIONS.Left:
		x_offset = -SEGMENT_LENGTH
	elif laser_direction == DIRECTIONS.Right:
		x_offset = SEGMENT_LENGTH
	elif laser_direction == DIRECTIONS.Up:
		y_offset = -SEGMENT_LENGTH
	elif laser_direction == DIRECTIONS.Down:
		y_offset = SEGMENT_LENGTH
	
	# Setting points based on offset and laser length
	for i in range(0, laser_length):
		$Laser.add_point(Vector2(x_offset * i, y_offset * i))
		x_change += x_offset
		y_change += y_offset
	
	add_collision()

func _on_body_entered(body):
	if body.is_in_group("Player"):
		kill_player(body)

func kill_player(player):
	if not player.dead:
		player.call("die")
		get_node("/root/SFXPlayer").play_sfx("SFXShooterShoot")

func _on_timeout():
	if timed_laser == true:
		laser_on = !laser_on
		
		if laser_on:
			$Laser.set_visible(true)
			$LaserCollision.shape_owner_set_disabled(collision_shape, false)
			
		else:
			$Laser.set_visible(false)
			$LaserCollision.shape_owner_set_disabled(collision_shape, true)
		
		$TimedTimer.stop()
		$TimedTimer.start()

func add_collision():
	var shape = SegmentShape2D.new()
	shape.set_a(Vector2(self.x_change, self.y_change))
	shape.set_b(Vector2(0, 0))
	
	collision_shape = $LaserCollision.create_shape_owner(self)
	$LaserCollision.shape_owner_add_shape(collision_shape, shape)
	