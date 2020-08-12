tool
extends Spawnable
class_name Enemy

var rotation_speed: float setget, get_rotation_speed

func get_rotation_speed() -> float:
	return self.speed / 100

func _physics_process(delta: float) -> void:
	if Engine.editor_hint:
		return
	
	rotate(self.rotation_speed * delta * Global.time_scale)
