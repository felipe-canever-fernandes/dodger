extends Control

onready var start_from_high_button: Button = $CenterContainer/VBoxContainer/StartFromHighContainer/StartFromHighButton

onready var transition: Transition = $Transition
onready var container: Container = $CenterContainer

func _ready() -> void:
	start_from_high_button.text = "Start From Level " + str(Global.high_level)
	transition.container = container

func _input(_event : InputEvent) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().quit()

func _on_StartFrom1Button_pressed() -> void:
	start_game(1)

func _on_StartFromHighButton_pressed():
	start_game(Global.high_level)

func start_game(starting_level: int) -> void:
	yield(transition.play(), "completed")
	
	Global.starting_level = starting_level
	
	# warning-ignore:return_value_discarded
	get_tree().change_scene_to(Screens.LEVEL_SCENE)

func _on_BackButton_pressed():
	yield(transition.play(), "completed")
	
	# warning-ignore:return_value_discarded
	get_tree().change_scene_to(Screens.MAIN_MENU_SCENE)
