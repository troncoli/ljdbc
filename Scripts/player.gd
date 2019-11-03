extends KinematicBody2D

export (int) var speed = 300

var velocity = Vector2()

func get_input():
	velocity = Vector2()
	if Input.is_key_pressed(KEY_K):
		$AnimatedSprite.play("attack")
	else:
		if Input.is_action_pressed('ui_right'):
			velocity.x += 1
			$AnimatedSprite.flip_h = false
		if Input.is_action_pressed('ui_left'):
			velocity.x -= 1
			$AnimatedSprite.flip_h = true
		if Input.is_action_pressed('ui_down'):
			velocity.y += 1
		if Input.is_action_pressed('ui_up'):
			velocity.y -= 1
		if velocity.length() > 0:
			velocity = velocity.normalized() * speed
			$AnimatedSprite.play("walking")
		else:
			$AnimatedSprite.play("idle")

func _physics_process(delta):
	get_input()
	velocity = move_and_slide(velocity)