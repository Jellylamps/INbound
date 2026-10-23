# Audio used was sourced from pixabay.com
# https://pixabay.com/sound-effects/film-special-effects-exercise-ball-drumming-56511/
# https://pixabay.com/sound-effects/film-special-effects-sword-clash-241729/
# https://pixabay.com/sound-effects/musical-kick-rubber-tube-82839/
# https://pixabay.com/sound-effects/film-special-effects-wine-cork-pop-352295/

extends CharacterBody2D

var speed = 2700
var direction = Vector2.ZERO
var buffer_velocity = Vector2.ZERO
var frozen = false
var impact = false
var active = false
var playerUncatch = true
var opponentUncatch = false
var stolen = false
var rethrow = true
var parried = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func freeze():
	if !frozen:
		buffer_velocity = velocity
		velocity = Vector2.ZERO
		frozen = true

func parry_freeze():
	$ParryFreeze.start()
	freeze()

func unfreeze():
	frozen = false
	if velocity == Vector2.ZERO:
		velocity = buffer_velocity

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	var player = get_parent().get_node("Player")
	var opponent = get_parent().get_node("Player2")
	# ball can't hit opponent when inactive
	if !active:
		set_collision_mask_value(8,false)
		set_collision_mask_value(5,false)
		set_collision_mask_value(4,false)
		rethrow = true
		parried = false
	else:
		set_collision_mask_value(8,true)
		if !stolen:
			set_collision_mask_value(5,true)
			set_collision_mask_value(4,false)
		else:
			set_collision_mask_value(5,false)
			set_collision_mask_value(4,true)
		
	var collision = move_and_collide(delta * velocity)
	if collision:
		if collision.get_collider_shape() == player.get_node("CollisionShape2D") and player.catching and !playerUncatch:
			active = false
			$Catch.play()
		if collision.get_collider_shape() == player.get_node("CollisionShape2D") and player.parrying and !playerUncatch and active:
			stolen = false
			parried = true
			$Parry.play()
			direction = Vector2(opponent.position.x - position.x, opponent.position.y - position.y).normalized()
			velocity = velocity.length() * 1.5 * direction
			# velocity = velocity * 1.5
			if velocity.length() > 6000:
				velocity = velocity.normalized() * 6000
			player.parrying = false
			player.can_parry = true
			player.smoke = true
			get_parent().parry_freeze(self)
		elif collision.get_collider_shape() == player.get_node("CollisionShape2D") and !player.catching and stolen:
			stolen = false
			if parried and get_parent().carrying:
				get_parent().opponentScore += 1
			player.reset()
			active = false
		if collision.get_collider_shape() == opponent.get_node("CollisionShape2D") and opponent.catching and !opponentUncatch:
			stolen = true
			active = false
			$Catch.play()
		if collision.get_collider_shape() == opponent.get_node("CollisionShape2D") and opponent.parrying and !opponentUncatch and active:
			stolen = true
			parried = true
			$Parry.play()
			direction = Vector2(player.position.x - position.x, player.position.y - position.y).normalized()
			velocity = velocity.length() * 1.5 * direction
			# velocity = velocity * -1.5
			if velocity.length() > 4000:
				velocity = velocity.normalized() * 4000
			opponent.parrying = false
			opponent.can_parry = true
			opponent.smoke = true
			get_parent().parry2_freeze(self)
		elif collision.get_collider_shape() == opponent.get_node("CollisionShape2D") and !opponent.catching and !stolen:
			if parried and get_parent().carrying2:
				get_parent().playerScore += 1
			opponent.reset()
			active = false
		else:
			velocity = velocity.bounce(collision.get_normal())
			if active: $Bounce.play()

func launch(angle):
	$Rethrow.start()
	active = true
	rethrow = false
	velocity = angle * speed
	velocity = velocity.normalized() * 1400
	$Trail.clear()
	$Throw.play()


func _on_rethrow_timeout():
	rethrow = true


func _on_parry_freeze_timeout():
	unfreeze()
