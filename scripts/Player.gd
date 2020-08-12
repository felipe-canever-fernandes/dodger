tool
extends Movable
class_name Player

signal shield_enabled
signal shield_disabled

export(AudioStream) var shield_sound: AudioStream
export(AudioStream) var slow_motion: AudioStream
export(AudioStream) var powerup_over_sound: AudioStream

onready var shape := $CollisionPolygon2D
onready var extent_shape: CollisionShape2D = $CollisionShape2D

onready var shield: Sprite = $Shield
onready var shield_timer: Timer = $Shield/Timer

const ROTATION_SPEED := 25.0

var extents := Vector2.ZERO
var previous_position := Vector2.ZERO

var has_powerup := false

func _ready() -> void:
	extents = (extent_shape.shape as RectangleShape2D).extents

func _process(delta : float) -> void:
	if Engine.editor_hint:
		return
	
	position = get_viewport().get_mouse_position()
	
	if previous_position != position:
		var direction := (previous_position - position).normalized()
		rotation = lerp_angle(rotation, direction.angle(), ROTATION_SPEED * delta)
		
	previous_position = position
	
	position.x = clamp(position.x,
		extents.x, get_viewport_rect().size.x - extents.x)
		
	position.y = clamp(position.y,
		extents.y, get_viewport_rect().size.y - extents.y)

func _on_ShieldTimer_timeout() -> void:
	disable_shield()

func enable_shield() -> void:
	shield.show()
	has_powerup = true
	shape.call_deferred("set_disabled", true)
	shield_timer.start()
	emit_signal("shield_enabled")

func disable_shield() -> void:
	shield.hide()
	has_powerup = false
	shape.call_deferred("set_disabled", false)
	emit_signal("shield_disabled")
