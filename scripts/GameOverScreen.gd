class_name GameOverScreen
extends CenterContainer

onready var high_score_label: Label = $VBoxContainer/HighScoreLabel
onready var high_level_label: Label = $VBoxContainer/HighLevelLabel

func _ready() -> void:
	high_score_label.text = "High Score: %s" % Global.high_score
	high_level_label.text = "High Level: %s" % Global.high_level
