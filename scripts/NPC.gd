extends Movable
class_name Spawnable

var direction := Vector2.ZERO
var speed := 0.0

func _process(delta : float) -> void:
	if Engine.editor_hint:
		return
		
	position += direction * self.speed * delta * Global.time_scale

func _on_VisibilityNotifier2D_viewport_exited(_viewport : Viewport) -> void:
	queue_free()
