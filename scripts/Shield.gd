extends Powerup
class_name Shield

func _on_Shield_area_entered(player: Player) -> void:
	if player.has_powerup:
		return
	
	player.enable_shield()
	queue_free()
