class_name GameOverScreen
extends CenterContainer

const _NEW_GAME_MENU_SCENE := preload("res://menus/NewGameMenu.tscn")
const _LEVEL_SCENE := preload("res://levels/Main.tscn")
const _MAIN_MENU_SCENE := preload("res://menus/MainMenu.tscn")

onready var _high_score_label: Label = $VBoxContainer/HighScoreLabel
onready var _high_level_label: Label = $VBoxContainer/HighLevelLabel

func _ready() -> void:
	_high_score_label.text = "High Score: %s" % Global.high_score
	_high_level_label.text = "High Level: %s" % Global.high_level

func _on_NewGameButton_pressed() -> void:
	_create_new_game()

func _on_MainMenuButton_pressed() -> void:
	_go_to_main_menu()

func _create_new_game() -> void:
	var scene := _LEVEL_SCENE \
			if Global.high_level == 1 \
			else _NEW_GAME_MENU_SCENE
	
	# warning-ignore:return_value_discarded
	get_tree().change_scene_to(scene)

func _go_to_main_menu() -> void:
	# warning-ignore:return_value_discarded
	get_tree().change_scene_to(_MAIN_MENU_SCENE)
