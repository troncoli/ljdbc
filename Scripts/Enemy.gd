extends KinematicBody2D

# stats
export (int) var speed = 125
export (int) var damage = 5
export (int) var health = 10

var velocity = Vector2()
var player

func _ready():
	# Get player reference
	var players = get_tree().get_nodes_in_group("Player")
	if players.size() > 0:
		player = players[0]

func _process(delta):
	if player and $AttackTimer.is_stopped():
		# Update direction
		var playerAngle = position.angle_to_point(player.get_central_position()) + PI/2
		$PlayerDetection.rotation = playerAngle
		# Detect player
		var body = $PlayerDetection.get_collider()
		if body and body.name == "Player":
			#$AnimatedSprite.play("attack")
			$AttackTimer.start(1.0)
			print("ENEMY ATTACK")

func _physics_process(delta):
	if player and $AttackTimer.is_stopped():
		# move toward player
		var vector = (player.get_central_position() - self.position)
		if (vector.length() > 42):
			velocity = vector.normalized() * speed
			move_and_slide(velocity)

func _on_Hitbox_body_entered(body):
	pass

func _on_AttackTimer_timeout():
	#$AnimatedSprite.play("walk")
	for body in $PlayerDetection/Hitbox.get_overlapping_bodies():
		if body.name == "Player":
			# TODO Hit Function
			body.hit(damage)

func hit(damage):
	# Enable death animation
	#$AnimatedSprite.play("death")
	queue_free() # temp destroy function

func _on_AnimatedSprite_animation_finished():
	if $AnimatedSprite.animation == "death":
		queue_free()
