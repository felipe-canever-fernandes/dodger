extends Tween
class_name Transition

const FINAL_MODULATE := Color(1, 1, 1, 0)

var container: Container = null

func play() -> void:
	get_tree().call_group("Buttons", "set_disabled", true)
	
	# warning-ignore:return_value_discarded
	interpolate_property(container, "modulate",
		null, FINAL_MODULATE, 0.5)
	
	# warning-ignore:return_value_discarded
	start()
	
	yield(self, "tween_all_completed")
