class_name GameOverScreen
extends CenterContainer

onready var high_score_label: Label = $VBoxContainer/HighScoreLabel

func _ready() -> void:
	high_score_label.text = "High Score: %s" % Global.high_score
