# Audio used was sourced from pixabay.com
# https://pixabay.com/sound-effects/musical-mellowloop-93589/

extends Control


func _on_play_pressed():
	get_tree().change_scene_to_file("res://Arena.tscn")

func _on_tutorial_pressed():
	get_tree().change_scene_to_file("res://tutorial.tscn")

func _on_quit_pressed():
	get_tree().quit()
