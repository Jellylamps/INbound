extends CharacterBody2D

var speed = 300
var input_direction = Vector2.ZERO
var aim_direction = Vector2.ZERO
var buffer_direction = Vector2(1,0)
var frozen = false
var grabbing = false
var catching = false
var can_catch = true
var parrying = false
var can_parry = true
var thief = false
var smoke = false

func get_input():
	input_direction = Input.get_vector("stickleft","stickright","stickup","stickdown").normalized()
	input_direction = eval_keys()
	aim_direction = Input.get_vector("aimleft","aimright","aimup","aimdown")
	if !aim_direction:
		if input_direction:
			aim_direction = input_direction
		else:
			aim_direction = buffer_direction
	if parrying:
		aim_direction = buffer_direction
	buffer_direction = aim_direction
	if abs(angle_difference(input_direction.angle(), aim_direction.angle())) > 2*PI/3:
		input_direction = input_direction * 0.6
	velocity = input_direction * speed
	grabbing = Input.is_action_pressed("grab")
	catching = Input.is_action_pressed("catch") and can_catch and !frozen
	if catching:
		grabbing = false
	parry()
	throw()

func angle_difference(a1,a2):
	var dif = a1 - a2
	if abs(dif) > PI: dif = dif + (2*PI * -sign(dif))
	return dif

func eval_keys():
	if Input.is_action_pressed("keyup") and !Input.is_action_pressed("keydown"):
		if Input.is_action_pressed("keyleft") and !Input.is_action_pressed("keyright"):
			input_direction.x = -sqrt(2)/3
			input_direction.y = -sqrt(2)/3
		elif Input.is_action_pressed("keyright") and !Input.is_action_pressed("keyleft"):
			input_direction.x = sqrt(2)/3
			input_direction.y = -sqrt(2)/3
		else:
			input_direction.x = 0
			input_direction.y = -2.0/3
	elif Input.is_action_pressed("keydown") and !Input.is_action_pressed("keyup"):
		if Input.is_action_pressed("keyleft") and !Input.is_action_pressed("keyright"):
			input_direction.x = -sqrt(2)/3
			input_direction.y = sqrt(2)/3
		elif Input.is_action_pressed("keyright") and !Input.is_action_pressed("keyleft"):
			input_direction.x = sqrt(2)/3
			input_direction.y = sqrt(2)/3
		else:
			input_direction.x = 0
			input_direction.y = 2.0/3
	elif Input.is_action_pressed("keyleft") and !Input.is_action_pressed("keyright"):
		input_direction.x = -2.0/3
		input_direction.y = 0
	elif Input.is_action_pressed("keyright") and !Input.is_action_pressed("keyleft"):
		input_direction.x = 2.0/3
		input_direction.y = 0
	return input_direction

func parry():
	if Input.is_action_just_pressed("parry") and can_parry and !frozen:
		parrying = true
		can_parry = false
		$ParryUptime.start(0.25)
		$Unparry.start(0.6)
	if parrying:
		$ParryTexture.visible = true
		if frozen:
			$ParryUptime.set_paused(true)
		else:
			$ParryUptime.set_paused(false)
	elif !frozen:
		$ParryTexture.visible = false

func throw():
	var playerBall = get_parent().get_node("PlayerBall")
	var opponentBall = get_parent().get_node("PlayerBall2")
	if Input.is_action_just_pressed("grab") and !catching and !parrying and opponentBall.stolen and !opponentBall.active and !frozen:
		opponentBall.position = position
		opponentBall.launch(aim_direction)
	elif Input.is_action_just_pressed("throw") and !catching and !parrying and !playerBall.stolen  and playerBall.rethrow and !frozen:
		playerBall.position = position
		playerBall.launch(aim_direction)

func freeze():
	frozen = true

func unfreeze():
	frozen = false

func reset():
	get_parent().playerCollide = false
	position.x = 100
	position.y = 360
	aim_direction = Vector2.ZERO
	buffer_direction = Vector2(1,0)
	get_parent().get_node("PlayerBall2").stolen = false
	get_parent().get_node("PlayerBall2").active = false
	get_parent().get_node("PlayerSlowAngle").rotation = 0
	thief = false

func tangible():
	if catching or parrying:
		speed = 0
		$CollisionShape2D.scale = Vector2(1.5,1.5)
		if !get_parent().get_node("PlayerBall").playerUncatch:
			set_collision_layer_value(8,true)
		else: set_collision_layer_value(8,false)
	else:
		set_collision_layer_value(8,false)
		speed = 300
		$CollisionShape2D.scale = Vector2(1,1)
		

func animate():
	if catching:
		$Animate.show()
		$Animate.play("catching")
	elif thief:
		$Animate.show()
		$Animate.play("stolen")
	elif smoke:
		$Animate.show()
		$Animate.play("parry")
	else:
		$Animate.stop()
		$Animate.hide()

func _physics_process(_delta):
	get_input()
	if grabbing: thief = false
	animate()
	if !catching and !parrying and !frozen:
		move_and_slide()
	tangible()
	if !frozen:
		rotation = aim_direction.angle()
		smoke = false


func _on_parry_uptime_timeout():
	parrying = false

func _on_unparry_timeout():
	can_parry = true

