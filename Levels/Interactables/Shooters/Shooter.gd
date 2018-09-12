extends StaticBody2D

const bullet = preload("res://Levels/Interactables/Shooters/Bullets/Bullet.tscn")

func _ready():
	shoot_bullet()

func create_bullet(pos, vel):
	var bullet_scene = bullet.instance()
	bullet_scene.set_transform(pos)
	bullet_scene.velocity = vel
	add_child(bullet_scene)

func shoot_bullet():
	var pos = $shoot.get_global_transform()
	create_bullet(pos, Vector2(0, -50))