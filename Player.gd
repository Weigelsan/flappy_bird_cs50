extends KinematicBody2D

export var gravity := 600.0
export var gravity_max := 800.0
export var jump_strength := 400.0

onready var gamelogic := get_parent()
onready var jumpsound := $JumpSound
onready var impactsound := $ImpactSound
onready var splatsound := $SplatSound
onready var blood_particles := $BloodParticles
onready var timer := $Timer
onready var sprite := $Sprite
onready var jump_particles := $JumpParticles

var velocity := Vector2(0.0, 0.0)
var is_dead := false

func _ready() -> void:
	set_physics_process(false)

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("jump") and not is_dead:
		jumpsound.play()
		velocity.y = -jump_strength
		jump_particles.emitting = true
	
	# Calculate rotation
	if velocity.y < 0:
		if sprite.rotation > deg2rad(-30):
			sprite.rotate(deg2rad(-4))
		else:
			sprite.rotation = deg2rad(-30)
	else:
		if sprite.rotation < deg2rad(60):
			sprite.rotate(deg2rad(2))
		else:
			sprite.rotation = deg2rad(60)
	
	# Apply gravity
	velocity.y += gravity * delta
	if (velocity.y >= gravity_max):
		velocity.y = gravity_max
	
	move_and_slide(velocity, Vector2.UP)

func start() -> void:
	set_physics_process(true)
	velocity.y = jump_strength

func _on_Area2D_area_entered(area: Area2D) -> void:
	if not area.is_in_group("score_area") and not is_dead:
		die()

func _on_Area2D_body_entered(body: Node) -> void:
	if not body.is_in_group("player"):
		blood_particles.emitting = false
		set_physics_process(false)
		$BloodExplosionParticles.emitting = true
		splatsound.play()
		gamelogic.dying()

func die() -> void:
	is_dead = true
	blood_particles.emitting = true
	impactsound.play()
