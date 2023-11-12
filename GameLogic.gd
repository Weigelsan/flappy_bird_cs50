extends Node

export var pillar :Resource
export var min_y := 50
export var max_y := 150
export var gap := 150
export var pillar_x_speed := 250.0
export var spawn_time := 1.0

onready var timer_pillar_spawn := $TimerPillarSpawn
onready var label := $Label
onready var audio_player := $AudioStreamPlayer
onready var player := $Player
onready var score_collision := $Player/Area2D
onready var ground_sprite := $Ground/Sprite
onready var background := $Background
onready var menu := $Menu
onready var menu_score := $Menu/PanelContainer/MarginContainer/VBoxContainer/HBoxScoreNumbers/Score_num
onready var menu_highscore := $Menu/PanelContainer/MarginContainer/VBoxContainer/HBoxScoreNumbers/Highscore_num
onready var menu_animation_player := $Menu/AnimationPlayer

var is_paused := true
var time := 0.0
var score := 0 setget set_score
var score_resource = null
var highscore = 0

const SAVE_GAME_PATH := "user://savegame.res"


func _ready() -> void:
	score_collision.connect("area_entered", self, "_on_ScoreArea_exited")
	ground_sprite.material.set_shader_param("speed", pillar_x_speed / 100)
	timer_pillar_spawn.wait_time = spawn_time
	max_y = get_viewport().get_size().y - max_y
	reset_shader()
	if ResourceLoader.exists(SAVE_GAME_PATH):
		score_resource = ResourceLoader.load(SAVE_GAME_PATH)
	if not score_resource:
		score_resource = Score.new()
		save_game()
	else:
		highscore = score_resource.score

func _physics_process(delta: float) -> void:
	if not is_paused:
		update_shader(delta)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("jump"):
		start_game()
		set_process_input(false)

func start_game() -> void:
	spawn_pillars()
	timer_pillar_spawn.start()
	player.start()
	is_paused = false

func spawn_pillars() -> void:
	var new_pillar = pillar.instance()
	var pillar_height = new_pillar.get_node("CollisionShape2D").get_shape().get_extents().y
	add_child(new_pillar)
	new_pillar.speed = pillar_x_speed
	new_pillar.get_node("CollisionShape2D2").position.y = pillar_height * 2 + gap
	var y_pos = round(rand_range(-pillar_height + min_y, -pillar_height + max_y - gap))
	new_pillar.global_position = Vector2(get_viewport().get_size().x + 100, y_pos)

func _on_Timer_timeout() -> void:
	if not is_paused:
		spawn_pillars()

func set_score(value: int) -> void:
	score = value
	label.text = str(score)
	audio_player.play()

func dying() -> void:
	if score > highscore:
		highscore = score
		save_game()
	is_paused = true
	for child in get_children():
		if child.is_in_group("pillar"):
			child.speed = 0
	label.hide()
	menu.show()
	menu_score.text = str(score)
	menu_highscore.text = str(highscore)
	get_tree().set_pause(true)

func _on_ScoreArea_exited(area: Area2D) -> void:
	if area.is_in_group("score_area") and not player.is_dead:
		self.score += 1

func save_game() -> void:
	score_resource.score = score
	ResourceSaver.save(SAVE_GAME_PATH, score_resource)

func _create_save_game() -> void:
	Resource.save(SAVE_GAME_PATH, score_resource)

## SHADER STUFF

func update_shader(delta: float) -> void:
	ground_sprite.material.set_shader_param("time", time)
	background.material.set_shader_param("time", time)
	time += delta

func reset_shader() -> void:
	ground_sprite.material.set_shader_param("time", 0)
	background.material.set_shader_param("time", 0)
