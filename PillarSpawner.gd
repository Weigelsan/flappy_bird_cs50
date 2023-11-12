extends Node

export var pillar :Resource
export var min_y := 50
export var max_y := 50
export var gap := 150
export var pillar_x_speed := 250
export var spawn_time := 1.0

onready var timer := $Timer

func _ready() -> void:
	timer.wait_time = spawn_time
	timer.start()
	max_y = get_viewport().get_size().y - max_y
	spawn_pillars()

func _physics_process(delta: float) -> void:
	pass


func spawn_pillars() -> void:
	var new_pillar = pillar.instance()
	var pillar_height = new_pillar.get_node("CollisionShape2D").get_shape().get_extents().y
	print("Pillar height: " + str(pillar_height))
	add_child(new_pillar)
	new_pillar.speed = pillar_x_speed
	new_pillar.get_node("CollisionShape2D2").position.y = pillar_height * 2 + gap
#	var y_pos = randi() % min_y - (pillar_height)
	var y_pos = round(rand_range(-pillar_height + min_y, -pillar_height + max_y - gap))
	print("y_pos: " + str(y_pos))
	new_pillar.global_position = Vector2(get_viewport().get_size().x + 100, y_pos)
	print("Real Y: " + str(new_pillar.global_position))


func _on_Timer_timeout() -> void:
	spawn_pillars()
