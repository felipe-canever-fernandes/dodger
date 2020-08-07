tool
extends "res://scripts/Mob.gd"
class_name Player

onready var shape := $CollisionShape2D

onready var shield := $Shield
onready var shield_timer := $Shield/Timer

const ROTATION_SPEED := 25.0

var extents := Vector2.ZERO
var previous_position := Vector2.ZERO

func _ready() -> void:
	extents = (shape.shape as RectangleShape2D).extents

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

func enable_shield() -> void:
	set_collision_layer_bit(0, false)
	
	shield.visible = true
	shield_timer.start()

func _on_ShieldTimer_timeout():
	set_collision_layer_bit(0, true)
	shield.visible = false
