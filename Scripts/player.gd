extends KinematicBody2D

export (int) var speed = 300

var Projectile = preload("res://Objects/projectile-fireball.tscn")
var Slash = preload("res://Objects/slash-2.tscn")
var velocity = Vector2()

var lastPressed = 'ui_up'

#walking
export (float) var canWalkCooldown = 0.5
var canWalkTimer = canWalkCooldown
var canWalk = true

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
		if Input.is_action_pressed('ui_left'):
			velocity.x -= 1
			$AnimatedSprite.flip_h = true
			lastPressed = 'ui_left'
		if Input.is_action_pressed('ui_down'):
			velocity.y += 1
			lastPressed = 'ui_down'
		if Input.is_action_pressed('ui_up'):
			velocity.y -= 1
			lastPressed = 'ui_up'
		if velocity.length() > 0 && canWalk:
			velocity = velocity.normalized() * speed
			$AnimatedSprite.play("walking")
		elif shooting and shootingTimer > shootingCooldown/2:
			$AnimatedSprite.play("attack")
		elif meleeing and meleeTimer > meleeCooldown/2:
			$AnimatedSprite.play("attack")
		else:
			$AnimatedSprite.play("idle")

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