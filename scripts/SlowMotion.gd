extends Powerup
class_name SlowMotion

signal picked_up

func _on_area_entered(_player: Player) -> void:
	emit_signal("picked_up")
