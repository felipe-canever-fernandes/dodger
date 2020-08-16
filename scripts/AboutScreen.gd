class_name AboutScreen
extends Control

onready var _transition: Transition = $Transition
onready var _container: Container = $CenterContainer

func _ready() -> void:
	_transition.container = _container

func _on_MainMenuButton_pressed() -> void:
	yield(_transition.play(), "completed")
	
	# warning-ignore:return_value_discarded
	get_tree().change_scene_to(Screens.MAIN_MENU_SCENE)
