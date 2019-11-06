extends KinematicBody2D

func start(pos, dir, lastPressed):
	rotation = dir
	position = pos
	
	if lastPressed == 'ui_right':
		$AnimatedSprite.flip_h = false
	elif lastPressed == 'ui_left':
		$AnimatedSprite.flip_h = true

func _on_AnimatedSprite_animation_finished():
	queue_free()
