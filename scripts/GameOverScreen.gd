class_name GameOverScreen
extends Control

var score := 0 setget set_score
var level := 0 setget set_level

onready var _transition: Transition = $Transition
onready var _container: Container = $CenterContainer

onready var _score_label: Label = $CenterContainer/VBoxContainer/ScoreLabel
onready var _high_score_label: Label = \
		$CenterContainer/VBoxContainer/HighScoreLabel

onready var _level_label: Label = $CenterContainer/VBoxContainer/LevelLabel
onready var _high_level_label: Label = \
		$CenterContainer/VBoxContainer/HighLevelLabel

func _ready() -> void:
	_transition.container = _container
	
	_high_score_label.text = "High Score: %s" % Global.high_score
	_high_level_label.text = "High Level: %s" % Global.high_level

func set_score(value: int) -> void:
	_score_label.text = "Score: %s" % value

func set_level(value: int) -> void:
	_level_label.text = "Level: %s" % value

func _on_NewGameButton_pressed() -> void:
	yield(_transition.play(), "completed")
	_create_new_game()

func _on_MainMenuButton_pressed() -> void:
	yield(_transition.play(), "completed")
	_go_to_main_menu()

func _create_new_game() -> void:
	var scene: PackedScene = Screens.LEVEL_SCENE \
			if Global.high_level == 1 \
			else Screens.NEW_GAME_MENU_SCENE
	
	# warning-ignore:return_value_discarded
	get_tree().change_scene_to(scene)

func _go_to_main_menu() -> void:
	# warning-ignore:return_value_discarded
	get_tree().change_scene_to(Screens.MAIN_MENU_SCENE)

func _on_visibility_changed():
	if visible:
		_set_up()

func _set_up() -> void:
	get_tree().paused = true
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
