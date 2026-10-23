# Audio used was sourced from pixabay.com
# https://pixabay.com/sound-effects/musical-drum-loop-with-chords-240904/
# https://pixabay.com/sound-effects/film-special-effects-good-6081/

extends ColorRect

var playerCollide = false
var player2Collide = false
var playerCbuffer = false
var player2Cbuffer = false
var carrying = false
var carrying2 = false
var playerScore = 0
var opponentScore = 0
var goal = false
var pause = false
var end = false

func _process(delta):
	var player = $Player
	var player2 = $Player2
	var objective = $Objective
	var playerBall = $PlayerBall
	var player2Ball = $PlayerBall2
	
	
	if !pause:
		$PlayerScore.text = str(playerScore)
		$OpponentScore.text = str(opponentScore)
		$PlayerSlowAngle.position = player.position
		if player.input_direction and !player.parrying and !player.frozen: $PlayerSlowAngle.rotation = player.input_direction.angle()
		$Player2SlowAngle.position = player2.position
		if player2.input_direction and !player2.parrying and !player2.frozen: $Player2SlowAngle.rotation = player2.input_direction.angle()
		if Input.is_action_pressed("reset") or Input.is_action_pressed("reset2") or goal:
			$Goal.play()
			if !goal:
				playerScore = 0
				opponentScore = 0
			reset()
		if playerCollide and player.grabbing:
			objective.position = player.position
			carrying = true
		else:
			carrying = false
		if player2Collide and player2.grabbing:
			objective.position = player2.position
			carrying2 = true
		else:
			carrying2 = false
		if carrying or carrying2 or (objective.position.x == 640 and objective.position.y == 360):
			$Objective/ObjectiveWarning.start(2)
			$Objective/ObjectiveReset.start(3)
			objective.modulate = Color(255,255,255,255)
		if !playerBall.active:
			if !playerBall.stolen:
				playerBall.position = player.position
			else:
				playerBall.position = player2.position
				player2.thief = true
			playerBall.visible = false
		else: playerBall.visible = true
		
		if !player2Ball.active:
			if !player2Ball.stolen:
				player2Ball.position = player2.position
			else:
				player2Ball.position = player.position
				player.thief = true
			player2Ball.visible = false
		else: player2Ball.visible = true
		
	if carrying and $Player2/Holding.visible == false:
		$Player/Holding.show()
	else:
		$Player/Holding.hide()
	
	if carrying2 and $Player/Holding.visible == false:
		$Player2/Holding.show()
	else:
		$Player2/Holding.hide()
	pause_menu()
	if goal and (playerScore > 20 and (playerScore - opponentScore) > 1) or (opponentScore > 20 and (opponentScore - playerScore) > 1):
			end = true
			end_menu()
	goal = false

func freeze():
	var player = $Player
	var player2 = $Player2
	var playerBall = $PlayerBall
	var player2Ball = $PlayerBall2
	player.freeze()
	playerBall.freeze()
	player2.freeze()
	player2Ball.freeze()

func parry_freeze(b):
	$ParryFreeze.start()
	$Player.freeze()
	b.parry_freeze()

func parry2_freeze(b):
	$ParryFreeze2.start()
	$Player2.freeze()
	b.parry_freeze()

func unfreeze():
	var player = $Player
	var player2 = $Player2
	var playerBall = $PlayerBall
	var player2Ball = $PlayerBall2
	player.unfreeze()
	playerBall.unfreeze()
	player2.unfreeze()
	player2Ball.unfreeze()

func reset():
	$Objective.position.x = 640
	$Objective.position.y = 360
	$PlayerBall/Trail.clear()
	$PlayerBall2/Trail.clear()
	$Player.reset()
	$Player2.reset()
	$PlayerSlowAngle.rotation = 0
	$Player2SlowAngle.rotation = PI
	playerCollide = false
	player2Collide = false
	$PlayerBall.active = false
	$PlayerBall2.active = false
	end = false
	
func pause_menu():
	if Input.is_action_just_pressed("pause") and !end:
		if pause:
			$Pause_Menu.hide()
			Engine.time_scale = 1
			$Player.unfreeze()
			$Player2.unfreeze()
		else:
			$Pause_Menu.show()
			Engine.time_scale = 0
			$Player.freeze()
			$Player2.freeze()
			$Pause_Menu/MarginContainer/VBoxContainer/Resume._ready()
		pause = !pause

func menu_unpause():
	$Pause_Menu.hide()
	Engine.time_scale = 1
	$Player.unfreeze()
	$Player2.unfreeze()
	pause = false

func end_menu():
	if playerScore > opponentScore:
		$End/Label.text = "Purple wins the game!"
	else:
		$End/Label.text = "Orange wins the game!"
	$End.show()
	Engine.time_scale = 0
	$Player.freeze()
	$Player2.freeze()
	$End/MarginContainer/VBoxContainer/Replay._ready()

func restart():
	$Goal.play()
	playerScore = 0
	opponentScore = 0
	$End.hide()
	Engine.time_scale = 1
	$Player.unfreeze()
	$Player2.unfreeze()
	reset()


func _on_objective_body_shape_entered(_body_rid, body, _body_shape_index, _local_shape_index):
	if body == $Player: playerCollide = true
	if body == $Player2: player2Collide = true

func _on_objective_body_shape_exited(_body_rid, body, _body_shape_index, _local_shape_index):
	if body == $Player: playerCollide = false
	if body == $Player2: player2Collide = false


func _on_left_goal_area_shape_entered(_area_rid, area, _area_shape_index, _local_shape_index):
	if area == $Objective:
		opponentScore += 1
		goal = true

func _on_right_goal_area_shape_entered(_area_rid, area, _area_shape_index, _local_shape_index):
	if area == $Objective:
		playerScore += 1
		goal = true


func _on_player_uncatch_body_shape_entered(_body_rid, body, _body_shape_index, _local_shape_index):
	if body == $PlayerBall and $PlayerBall.active:
		$PlayerBall.playerUncatch = true
	if body == $PlayerBall2 and $PlayerBall2.active:
		$PlayerBall.opponentUncatch = true

func _on_player_uncatch_body_shape_exited(_body_rid, body, _body_shape_index, _local_shape_index):
	if body == $PlayerBall:
		$PlayerBall.playerUncatch = false
	if body == $PlayerBall2:
		$PlayerBall.opponentUncatch = false


func _on_objective_warning_timeout():
	$Objective.modulate = Color(255,0,0,255) 


func _on_objective_reset_timeout():
	$Objective.position.x = 640
	$Objective.position.y = 360
	$Objective.modulate = Color(255,255,255,255)


func _on_player_2_uncatch_body_shape_entered(_body_rid, body, _body_shape_index, _local_shape_index):
	if body == $PlayerBall2 and $PlayerBall2.active:
		$PlayerBall2.player2Uncatch = true
	if body == $PlayerBall and $PlayerBall.active:
		$PlayerBall2.opponentUncatch = true


func _on_player_2_uncatch_body_shape_exited(_body_rid, body, _body_shape_index, _local_shape_index):
	if body == $PlayerBall2:
		$PlayerBall2.player2Uncatch = false
	if body == $PlayerBall:
		$PlayerBall2.opponentUncatch = false


func _on_parry_freeze_timeout():
	$Player.unfreeze()


func _on_parry_freeze_2_timeout():
	$Player2.unfreeze()
