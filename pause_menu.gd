extends Control


func _on_resume_pressed():
	$"../".menu_unpause()

func _on_menu_pressed():
	$"../".menu_unpause()
	get_tree().change_scene_to_file("res://main_menu.tscn")

func _on_quit_pressed():
	get_tree().quit()
