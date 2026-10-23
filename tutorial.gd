# Audio used was sourced from pixabay.com
# https://pixabay.com/sound-effects/musical-mellowloop-93589/

extends Control

func _process(delta):
	if Input.is_action_just_pressed("ui_accept"):
		if $ColorRect.visible:
			$ColorRect.hide()
			$Dark.hide()
			$BasicsText.hide()
			$MovementText.hide()
			$BallText.hide()
			$MarginContainer/VBoxContainer/Basics.disabled = !$MarginContainer/VBoxContainer/Basics.disabled
			$MarginContainer/VBoxContainer/Movement.disabled = !$MarginContainer/VBoxContainer/Movement.disabled
			$MarginContainer/VBoxContainer/BallMech.disabled = !$MarginContainer/VBoxContainer/BallMech.disabled
			$MarginContainer/VBoxContainer/Menu.disabled = !$MarginContainer/VBoxContainer/Menu.disabled

func _on_basics_pressed():
	$ColorRect.show()
	$Dark.show()
	$BasicsText.show()
	$MarginContainer/VBoxContainer/Basics.disabled = !$MarginContainer/VBoxContainer/Basics.disabled
	$MarginContainer/VBoxContainer/Movement.disabled = !$MarginContainer/VBoxContainer/Movement.disabled
	$MarginContainer/VBoxContainer/BallMech.disabled = !$MarginContainer/VBoxContainer/BallMech.disabled
	$MarginContainer/VBoxContainer/Menu.disabled = !$MarginContainer/VBoxContainer/Menu.disabled

func _on_movement_pressed():
	$ColorRect.show()
	$Dark.show()
	$MovementText.show()
	$MarginContainer/VBoxContainer/Basics.disabled = !$MarginContainer/VBoxContainer/Basics.disabled
	$MarginContainer/VBoxContainer/Movement.disabled = !$MarginContainer/VBoxContainer/Movement.disabled
	$MarginContainer/VBoxContainer/BallMech.disabled = !$MarginContainer/VBoxContainer/BallMech.disabled
	$MarginContainer/VBoxContainer/Menu.disabled = !$MarginContainer/VBoxContainer/Menu.disabled

func _on_ball_mech_pressed():
	$ColorRect.show()
	$Dark.show()
	$BallText.show()
	$MarginContainer/VBoxContainer/Basics.disabled = !$MarginContainer/VBoxContainer/Basics.disabled
	$MarginContainer/VBoxContainer/Movement.disabled = !$MarginContainer/VBoxContainer/Movement.disabled
	$MarginContainer/VBoxContainer/BallMech.disabled = !$MarginContainer/VBoxContainer/BallMech.disabled
	$MarginContainer/VBoxContainer/Menu.disabled = !$MarginContainer/VBoxContainer/Menu.disabled

func _on_menu_pressed():
	get_tree().change_scene_to_file("res://main_menu.tscn")
