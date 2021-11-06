extends Control


func _on_Play_pressed():
# warning-ignore:return_value_discarded
	get_tree().change_scene("res://Scenes/Game Scene.tscn")


func _on_Edit_pressed():
# warning-ignore:return_value_discarded
	get_tree().change_scene("res://Scenes/Edit Scene.tscn")


func _on_Quit_pressed():
	get_tree().quit()
