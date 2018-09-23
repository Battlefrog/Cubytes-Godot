extends StaticBody2D

const DIRECTIONS = {Left = 0, Right = 1, Up = 2, Down = 3}

export(DIRECTIONS) var laser_direction
export(int) var laser_length

func _ready():
	var x_offset = 0
	var y_offset = 0
	
	var x_change = 0
	var y_change = 0
	
	# Setting offset based on direction
	if laser_direction == DIRECTIONS.Left:
		x_offset = -16
	elif laser_direction == DIRECTIONS.Right:
		x_offset = 16
	elif laser_direction == DIRECTIONS.Up:
		y_offset = -16
	elif laser_direction == DIRECTIONS.Down:
		y_offset = 16
	
	# Setting points based on offset and laser length
	for i in range(0, laser_length):
		$Laser.add_point(Vector2(x_offset * i, y_offset * i))
		x_change += x_offset
		y_change += y_offset
	
	# Setting the collisions for the laser
	$LaserCollision/LaserCollisionShape.get_shape().set_a(Vector2(x_change, y_change))

func _on_body_entered(body):
	if body.is_in_group("Player"):
		kill_player(body)

func kill_player(player):
	if not player.dead:
		player.call("die")
		get_node("/root/SFXPlayer").play_sfx("SFXShooterShoot")