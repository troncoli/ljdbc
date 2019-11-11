extends KinematicBody2D

var speed = 500
var damage = 10
var velocity = Vector2()

func start(pos, dir):
	rotation = dir
	position = pos
	velocity = Vector2(speed, 0).rotated(rotation)
	
	if velocity.x > 0:
		$AnimatedSprite.rotation = -PI/2
	elif velocity.x < 0:
		$AnimatedSprite.rotation = -PI/2
	elif velocity.y > 0:
		$AnimatedSprite.rotation = PI
	elif velocity.y < 0:
		$AnimatedSprite.rotation = 0

func _physics_process(delta):
	var collision = move_and_collide(velocity * delta)
	if collision:
		if collision.collider.name == "Enemy":
			collision.collider.hit(damage)
		queue_free()