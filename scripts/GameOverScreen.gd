class_name GameOverScreen
extends CenterContainer

const NEW_GAME_MENU_SCENE := preload("res://menus/NewGameMenu.tscn")
const LEVEL_SCENE := preload("res://levels/Main.tscn")

onready var high_score_label: Label = $VBoxContainer/HighScoreLabel
onready var high_level_label: Label = $VBoxContainer/HighLevelLabel

func _ready() -> void:
	high_score_label.text = "High Score: %s" % Global.high_score
	high_level_label.text = "High Level: %s" % Global.high_level

func _on_NewGameButton_pressed() -> void:
	var scene := LEVEL_SCENE if Global.high_level == 1 else NEW_GAME_MENU_SCENE
	
	# warning-ignore:return_value_discarded
	get_tree().change_scene_to(scene)
