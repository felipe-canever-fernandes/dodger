extends Control
class_name HUD

onready var stats := $Stats/StatsContainer

onready var level_label := $Stats/StatsContainer/HBoxContainer/LevelContainer/LevelLabel
onready var high_level_label := $Stats/StatsContainer/HBoxContainer/LevelContainer/HighLevelLabel

onready var score_container := $Stats/StatsContainer/HBoxContainer/ScoreContainer

onready var score_label := $Stats/StatsContainer/HBoxContainer/ScoreContainer/ScoreLabel
onready var high_score_label := $Stats/StatsContainer/HBoxContainer/ScoreContainer/HighScoreLabel

onready var level_message_label := $Messages/LevelLabel
onready var message_timer := $MessageTimer

func _ready() -> void:
	score_container.visible = Global.starting_level == 1
	
	high_level_label.text = "High Level: " + str(Global.high_level)
	high_score_label.text = "High Score: " + str(Global.high_score)

func _on_Main_level_changed(level : int) -> void:
	level_label.text = "Level: " + str(level)
	
	level_message_label.visible = true
	level_message_label.text = "LEVEL " + str(level)
	message_timer.start()

func _on_Main_score_changed(score : int) -> void:
	score_label.text = "Score: " + str(score)

func _on_Main_high_score_surpassed() -> void:
	level_message_label.visible = true
	level_message_label.text = "NEW HIGH SCORE"
	message_timer.start()

func _on_MessageTimer_timeout():
	level_message_label.visible = false

func _on_hide() -> void:
	stats.hide()
	level_message_label.hide()
