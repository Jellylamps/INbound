extends Control


func _on_replay_pressed():
	$"../".restart()

func _on_menu_pressed():
	$"../".restart()
	get_tree().change_scene_to_file("res://main_menu.tscn")

func _on_quit_pressed():
	get_tree().quit()
