extends Node2D

signal level_changed(level)
signal score_changed(score)
signal high_score_surpassed

export(PackedScene) onready var Player : PackedScene
export(PackedScene) onready var Enemy : PackedScene
export(Array, PackedScene) onready var powerup_scenes: Array
export(PackedScene) onready var explosion_scene: PackedScene

export(AudioStream) var high_score_sound: AudioStream
export(AudioStream) var explosion_sound: AudioStream

export(float, 0, 1) var shield_spawn_chance := 0.05
export(float, 0, 1) var slow_motion_time_scale := 0.25

onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer

onready var enemySpawnTimer := $EnemySpawnTimer
onready var score_timer: Timer = $ScoreTimer
onready var slow_motion_timer: Timer = $SlowMotionTimer

onready var slow_motion_background: ColorRect = $BackgroundLayer/SlowMotion

onready var spawner : Path2D = $Spawner
onready var spawn_position : PathFollow2D = $Spawner/Position

onready var hud: Control = $HUDLayer/HUD
onready var pause_menu: Control = $HUDLayer/PauseMenu
onready var game_over_screen: Control = $HUDLayer/GameOverScreen

onready var flash_animation_player: AnimationPlayer = $HUDLayer/Flash/AnimationPlayer

const INITIAL_ENEMY_SPEED := 100.0
const ENEMY_SPEED_INCREMENT := 50.0

var random := RandomNumberGenerator.new()

var level : int setget set_level
var score : int setget set_score

var has_surpassed_high_score := false

var player : Player

func set_level(value : int) -> void:
	level = value
	emit_signal("level_changed", level)

func set_score(value : int) -> void:
	score = value
	emit_signal("score_changed", score)

func _ready() -> void:
	get_tree().paused = false
	
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	get_viewport().warp_mouse(get_viewport_rect().size / 2)
	
	random.randomize()
	
	self.level = Global.starting_level
	self.score = 0
	
	if Global.high_score == 0:
		has_surpassed_high_score = true
	
	instance_player()
	make_spawner()
	
	if Global.starting_level == 1:
		score_timer.start()
	
	Global.time_scale = 1.0

func _exit_tree() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	quit()

func instance(Scene : PackedScene, position : Vector2):
	var scene := Scene.instance()
	add_child(scene)
	
	scene.position = position
	return scene

func instance_player() -> void:
	player = instance(Player, get_viewport_rect().size / 2)
	
	# warning-ignore:return_value_discarded
	player.connect("shield_enabled", self, "on_Player_shield_enabled")
	# warning-ignore:return_value_discarded
	player.connect("shield_disabled", self, "on_Player_shield_disabled")

func on_Player_shield_enabled() -> void:
	audio_stream_player.stream = player.shield_sound
	audio_stream_player.play()

func on_Player_shield_disabled() -> void:
	audio_stream_player.stream = player.powerup_over_sound
	audio_stream_player.play()

func instance_spawnable(spawnable_scene: PackedScene) -> Spawnable:
	spawn_position.unit_offset = random.randf()
	var position := spawn_position.position
	
	var spawnable: Spawnable = instance(spawnable_scene, position)
	
	var middle := get_viewport_rect().size / 2
	spawnable.direction = spawnable.position.direction_to(middle)
	
	spawnable.direction = spawnable.direction.rotated(
		random.randf_range(-PI / 8, PI / 8))
	
	return spawnable

func instance_powerup() -> void:
	var i: int = random.randi_range(0, len(powerup_scenes) - 1)
	var scene: PackedScene = powerup_scenes[i]
	
	var powerup: Powerup = instance_spawnable(scene)
	
	if powerup is SlowMotion:
		var slow_motion: SlowMotion = powerup
		
		# warning-ignore:return_value_discarded
		slow_motion.connect("picked_up", self, "on_SlowMotion_picked_up",
			[slow_motion])

func make_spawner() -> void:
	var curve := spawner.curve
	var size := get_viewport_rect().size
	
	curve.add_point(Vector2(0, 0));
	curve.add_point(Vector2(size.x, 0));
	curve.add_point(Vector2(size.x, size.y));
	curve.add_point(Vector2(0, size.y));
	curve.add_point(Vector2(0, 0));

func _on_LevelTimer_timeout() -> void:
	enemySpawnTimer.wait_time = enemySpawnTimer.initial_wait_time
	self.level += 1

func _on_ScoreTimer_timeout() -> void:
	self.score += 1
	
	var new_wait_time : float = (enemySpawnTimer.wait_time
		- enemySpawnTimer.wait_time_decrement)
		
	if new_wait_time >= enemySpawnTimer.minimum_wait_time:
		enemySpawnTimer.wait_time = new_wait_time

func _on_EnemySpawnTimer_timeout() -> void:
	var enemy : Enemy = instance_spawnable(Enemy)
	
	# warning-ignore:return_value_discarded
	enemy.connect("area_entered", self, "_on_Enemy_area_entered")
	
	enemy.speed = (INITIAL_ENEMY_SPEED + ENEMY_SPEED_INCREMENT * self.level)

func _on_Enemy_area_entered(_area : Area) -> void:
	pause_menu.queue_free()
	explode()

func explode() -> void:
	audio_stream_player.stream = explosion_sound
	audio_stream_player.play()
	
	flash_animation_player.play("Flash")
	instance_explosion()
	player.queue_free()

func instance_explosion() -> void:
	var explosion: AnimatedSprite = explosion_scene.instance()
	add_child(explosion)
	
	# warning-ignore:return_value_discarded
	explosion.connect("animation_finished", self,
		"on_explosion_animation_finished")
		
	explosion.global_position = player.position
	explosion.play()

func on_explosion_animation_finished() -> void:
	end_game()

func end_game() -> void:
	hud.call_deferred("hide")
	
	game_over_screen.score = score
	game_over_screen.level = level
	
	game_over_screen.show()

func quit() -> void:
	if Global.starting_level == 1:
		if level > Global.high_level:
			Global.high_level = level
	
	if score > Global.high_score:
		Global.high_score = score
		
	# warning-ignore:return_value_discarded
	get_tree().change_scene_to(Screens.MAIN_MENU_SCENE)

func _on_PauseMenu_hide():
	get_viewport().warp_mouse(player.position)

func _on_PickupSpawnTimer_timeout() -> void:
	if not random.randf() <= shield_spawn_chance:
		return
	
	instance_powerup()

func on_SlowMotion_picked_up(slow_motion: SlowMotion) -> void:
	if player.has_powerup:
		return
	
	enable_slow_motion()
	slow_motion.queue_free()

func _on_SlowMotionTimer_timeout() -> void:
	disable_slow_motion()

func enable_slow_motion() -> void:
	player.has_powerup = true
	slow_motion_timer.start()
	Global.time_scale = slow_motion_time_scale
	slow_motion_background.show()
	
	audio_stream_player.stream = player.slow_motion
	audio_stream_player.play()

func disable_slow_motion() -> void:
	player.has_powerup = false
	Global.time_scale = 1.0
	slow_motion_background.hide()
	
	audio_stream_player.stream = player.powerup_over_sound
	audio_stream_player.play()

func _on_score_changed(_score: int):
	if not has_surpassed_high_score:
		if score > Global.high_score:
			has_surpassed_high_score = true
			emit_signal("high_score_surpassed")

func _on_high_score_surpassed() -> void:
	audio_stream_player.stream = high_score_sound
	audio_stream_player.play()
