extends Control

onready var high_score_label := $CenterContainer/VBoxContainer/HighScoreLabel
onready var high_level_label := $CenterContainer/VBoxContainer/HighLevelLabel

onready var transition: Transition = $Transition
onready var container: Container = $CenterContainer

func _on_NewGameButton_pressed() -> void:
	yield(transition.play(), "completed")
	
	var scene: PackedScene = Screens.LEVEL_SCENE \
			if Global.high_level == 1 \
			else Screens.NEW_GAME_MENU_SCENE
	
	# warning-ignore:return_value_discarded
	get_tree().change_scene_to(scene)

func _on_QuitButton_pressed() -> void:
	yield(transition.play(), "completed")
	get_tree().quit()

func _on_ResetHighScoreButton_pressed() -> void:
	Global.high_score = 0

func _on_ResetHighLevelButton_pressed() -> void:
	Global.high_level = 1

func _ready() -> void:
	OS.window_size = OS.get_screen_size()
	
	# warning-ignore:return_value_discarded
	Global.connect("high_score_changed", self, "on_high_score_changed")
	update_high_score_label()
	
	# warning-ignore:return_value_discarded
	Global.connect("high_level_changed", self, "on_high_level_changed")
	update_high_level_label()
	
	transition.container = container

func _input(_event : InputEvent) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().quit()

func on_high_score_changed() -> void:
	update_high_score_label()

func on_high_level_changed() -> void:
	update_high_level_label()

func update_high_score_label() -> void:
	high_score_label.text = "High Score: " + str(Global.high_score)

func update_high_level_label() -> void:
	high_level_label.text = "High Level: " + str(Global.high_level)

func _on_AboutButton_pressed() -> void:
	yield(transition.play(), "completed")
	
	# warning-ignore:return_value_discarded
	get_tree().change_scene_to(Screens.ABOUT_SCREEN_SCENE)
