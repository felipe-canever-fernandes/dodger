tool
extends Spawnable
class_name Enemy

var rotation_speed: float setget, get_rotation_speed

func get_rotation_speed() -> float:
	return self.speed / 100

func _physics_process(delta: float) -> void:
	rotate(self.rotation_speed * delta)
