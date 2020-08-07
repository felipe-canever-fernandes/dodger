extends Node2D

signal level_changed(level)
signal score_changed(score)

export(String, FILE) var main_menu_scene : String

export(PackedScene) onready var Player : PackedScene
export(PackedScene) onready var Enemy : PackedScene

export(Array, PackedScene) onready var Pickups : Array

onready var enemySpawnTimer := $EnemySpawnTimer
onready var score_timer: Timer = $ScoreTimer

onready var npcSpawner : Path2D = $NPCSpawner
onready var npcSpawnPosition : PathFollow2D = $NPCSpawner/SpawnPosition

onready var pause_menu: Control = $HUDLayer/PauseMenu

const INITIAL_ENEMY_SPEED := 100.0
const ENEMY_SPEED_INCREMENT := 50.0

var random := RandomNumberGenerator.new()

var level : int setget set_level
var score : int setget set_score

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
	
	instance_player()
	make_npc_spawner()
	
	if Global.starting_level == 1:
		score_timer.start()

func _exit_tree() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func instance(Scene : PackedScene, position : Vector2):
	var scene := Scene.instance()
	add_child(scene)
	
	scene.position = position
	return scene

func instance_player() -> void:
	player = instance(Player, get_viewport_rect().size / 2)

func instance_npc(Scene : PackedScene) -> NPC:
	npcSpawnPosition.unit_offset = random.randf()
	var position := npcSpawnPosition.position
	
	var npc : NPC = instance(Scene, position)
	
	var middle := get_viewport_rect().size / 2
	npc.direction = npc.position.direction_to(middle)
	npc.direction = npc.direction.rotated(random.randf_range(-PI / 8, PI / 8))
	
	return npc

func make_npc_spawner() -> void:
	var curve := npcSpawner.curve
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
	var enemy : Enemy = instance_npc(Enemy)
	
	# warning-ignore:return_value_discarded
	enemy.connect("area_entered", self, "_on_Enemy_area_entered")
	
	enemy.speed = (INITIAL_ENEMY_SPEED + ENEMY_SPEED_INCREMENT * self.level)

func _on_Enemy_area_entered(_area : Area) -> void:
	quit()

func quit() -> void:
	if Global.starting_level == 1:
		if level > Global.high_level:
			Global.high_level = level
	
	if score > Global.high_score:
		Global.high_score = score
	
	Global.save()
		
	# warning-ignore:return_value_discarded
	get_tree().change_scene(main_menu_scene)

func _on_Invulnerability_area_entered(_area : Area) -> void:
	player.enable_shield()

func _on_PauseMenu_hide():
	get_viewport().warp_mouse(player.position)
