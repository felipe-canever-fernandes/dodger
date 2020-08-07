extends Powerup
class_name Shield

func _on_Shield_area_entered(player: Player) -> void:
	player.enable_shield()
	queue_free()
