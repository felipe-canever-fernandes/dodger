class_name AboutScreen
extends Control

func _on_MainMenuButton_pressed() -> void:
	# warning-ignore:return_value_discarded
	get_tree().change_scene_to(Screens.MAIN_MENU_SCENE)
