tool
extends NPC
class_name Pickup

var pickable := true setget set_pickable, get_pickable

func set_pickable(value: bool) -> void:
	set_collision_mask_bit(0, value)

func get_pickable() -> bool:
	return get_collision_mask_bit(0)

func _on_area_entered(_area: Area2D):
	queue_free()
