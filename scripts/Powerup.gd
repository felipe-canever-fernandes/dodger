extends Spawnable
class_name Powerup

const INITIAL_SPEED := 100.0

func _ready() -> void:
	self.speed = INITIAL_SPEED
