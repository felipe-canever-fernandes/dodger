extends Timer

export var initial_wait_time := 0.25
export var wait_time_decrement := 0.1
export var minimum_wait_time := 0.1

func _ready() -> void:
	wait_time = initial_wait_time
