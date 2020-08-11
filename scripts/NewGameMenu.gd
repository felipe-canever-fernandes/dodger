extends Control

export(String, FILE) var game_scene : String
export(String, FILE) var main_menu_scene : String

onready var start_from_high_button: Button = $CenterContainer/VBoxContainer/StartFromHighContainer/StartFromHighButton

func _ready() -> void:
	start_from_high_button.text = "Start From Level " + str(Global.high_level)

func _input(_event : InputEvent) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().quit()

func _on_StartFrom1Button_pressed() -> void:
	Global.starting_level = 1
	
	# warning-ignore:return_value_discarded
	get_tree().change_scene(game_scene)

func _on_StartFromHighButton_pressed():
	Global.starting_level = Global.high_level
	
	# warning-ignore:return_value_discarded
	get_tree().change_scene(game_scene)

func _on_BackButton_pressed():
	# warning-ignore:return_value_discarded
	get_tree().change_scene(main_menu_scene)
