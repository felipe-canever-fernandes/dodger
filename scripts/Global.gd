extends Node

onready var save_file_dir := (OS.get_executable_path().get_base_dir()
	+ "\\save.json")

signal high_score_changed
var high_score : int setget set_high_score

func set_high_score(value : int) -> void:
	high_score = value
	emit_signal("high_score_changed")

signal high_level_changed
var high_level : int setget set_high_level

func set_high_level(value : int) -> void:
	high_level = value
	emit_signal("high_level_changed")

var starting_level := 1
var time_scale := 1.0

func _ready():
	print(save_file_dir)
	
	# warning-ignore:return_value_discarded
	connect("high_score_changed", self, "on_high_score_changed")
	
	if restore() != OK:
		self.high_level = 1
		self.high_score = 0

func save() -> void:
	var data := {
		"high_score": high_score,
		"high_level": high_level
	}
	
	var file := File.new()
	
	if file.open(save_file_dir, File.WRITE) != OK:
		print("Unable to save.")
	
	file.store_line(to_json(data))

func restore() -> int:
	var file := File.new()
	
	if file.open(save_file_dir, File.READ) != OK:
		print("Unable to load save.")
		return ERR_FILE_CANT_OPEN
	
	var data = parse_json(file.get_line())
	
	if not data:
		print("Unable to load save.")
		return ERR_FILE_CANT_OPEN
	
	high_level = data["high_level"]
	high_score = data["high_score"]
	
	return OK

func on_high_score_changed() -> void:
	save()
