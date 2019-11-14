extends KinematicBody2D

# stats
export (int) var speed = 300
export (int) var health = 100
var immune = false

var Projectile = preload("res://Objects/projectile-fireball.tscn")
var Slash = preload("res://Objects/slash-2.tscn")
var velocity = Vector2()

var lastPressed = 'ui_up'
var direction = Vector2.DOWN

#walking
export (float) var canWalkCooldown = 0.5
var canWalkTimer = canWalkCooldown
var canWalk = true

# Sprites with directions
var idleSprite = {
	Vector2.UP: "idleN",
	Vector2.DOWN: "idleS",
	Vector2.RIGHT: "idleE",
	Vector2.LEFT: "idleE",
}

var walkSprite = {
	Vector2.UP: "walkN",
	Vector2.DOWN: "walkS",
	Vector2.RIGHT: "walkE",
	Vector2.LEFT: "walkE",
}

#shoot
export (float) var shootingCooldown = 1.0
var shootingTimer = shootingCooldown
var shooting = false

#melee
export (float) var meleeCooldown = 0.5
var meleeTimer = meleeCooldown
var meleeing = false

func get_input():
	velocity = Vector2()
	if Input.is_key_pressed(KEY_K) and !shooting:
		shoot()
	elif Input.is_key_pressed(KEY_J) and !meleeing:
		melee()
	else:
		if Input.is_action_pressed('ui_right'):
			velocity.x += 1
			$AnimatedSprite.flip_h = false
			lastPressed = 'ui_right'
			direction = Vector2.RIGHT
		if Input.is_action_pressed('ui_left'):
			velocity.x -= 1
			$AnimatedSprite.flip_h = true
			lastPressed = 'ui_left'
			direction = Vector2.LEFT
		if Input.is_action_pressed('ui_down'):
			velocity.y += 1
			$AnimatedSprite.flip_h = false
			lastPressed = 'ui_down'
			direction = Vector2.DOWN
		if Input.is_action_pressed('ui_up'):
			velocity.y -= 1
			$AnimatedSprite.flip_h = false
			lastPressed = 'ui_up'
			direction = Vector2.UP
		if velocity.length() > 0 && canWalk:
			velocity = velocity.normalized() * speed
			$AnimatedSprite.play(walkSprite[direction])
		elif shooting and shootingTimer > shootingCooldown/2:
			$AnimatedSprite.play("attack")
		elif meleeing and meleeTimer > meleeCooldown/2:
			$AnimatedSprite.play("attack")
		else:
			$AnimatedSprite.play(idleSprite[direction])

func shoot():
	shooting = true
	$AnimatedSprite.play("attack")
	
	var p = Projectile.instance()
	var spawnPos = position
	var spawnRot = rotation
	
	if lastPressed == 'ui_right':
		spawnPos += Vector2.RIGHT * 60
		spawnRot = 0
	elif lastPressed == 'ui_left':
		spawnPos += Vector2.LEFT * 60
		spawnRot = PI
	elif lastPressed == 'ui_down':
		spawnPos += Vector2.DOWN * 80
		spawnRot = PI/2
	elif lastPressed == 'ui_up':
		spawnPos += Vector2.UP * 60
		spawnRot = -PI/2
	
	p.start(spawnPos, spawnRot)
	get_parent().add_child(p)

func melee():
	meleeing = true
	canWalk = false
	$AnimatedSprite.play("attack")
	
	var s = Slash.instance()
	var spawnPos = position
	var spawnRot = rotation
	
	if lastPressed == 'ui_right':
		spawnPos += Vector2.RIGHT * 20
	elif lastPressed == 'ui_left':
		spawnPos += Vector2.LEFT * 20
	elif lastPressed == 'ui_down':
		spawnPos += Vector2.DOWN * 40
		spawnRot = PI/2
	elif lastPressed == 'ui_up':
		spawnPos += Vector2.UP * 30
		spawnRot = -PI/2
	
	s.start(spawnPos, spawnRot, lastPressed)
	get_parent().add_child(s)

func _physics_process(delta):
	get_input()
	
	if shooting:
		shootingTimer -= delta
		if shootingTimer <= 0.0:
			shooting = false
			shootingTimer = shootingCooldown
	
	if meleeing:
		meleeTimer -= delta
		if meleeTimer <= 0.0:
			meleeing = false
			meleeTimer = meleeCooldown
	
	if !canWalk:
		canWalkTimer -= delta
		if canWalkTimer <= 0.0:
			canWalk = true
			canWalkTimer = canWalkCooldown
	
	if canWalk:
		velocity = move_and_slide(velocity)

func get_central_position():
	return $CollisionShape2D.get_global_transform().origin
	
func hit(damage):
	if not immune:
		health = health - damage
		print("PLAYER HEALTH : " + str(health))
		# is dead
		if health <= 0:
			die()
			return
		# enable immunity
		immune = true
		$ImmuneTimer.start()
		$SpriteTimer.start()

func die():
	pass # launch game over

func _on_ImmuneTimer_timeout():
	immune = false
	$SpriteTimer.stop()
	$AnimatedSprite.show()

func _on_SpriteTimer_timeout():
	$AnimatedSprite.visible = not $AnimatedSprite.visible
