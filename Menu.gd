extends CanvasLayer

onready var timer := $TimerMenuShow
onready var animation_player := $AnimationPlayer

export var show_up_time := 1.0

var ready := false

func _ready() -> void:
	timer.set_wait_time(show_up_time)

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("jump") and ready:
		animation_player.play("slide_out")

func _on_RetryButton_pressed() -> void:
	if ready:
		animation_player.play("slide_out")

func _on_AnimationPlayer_animation_finished(anim_name: String) -> void:
	if anim_name == "slide_out":
		get_tree().reload_current_scene()
		get_tree().set_pause(false)
		hide()
	if anim_name == "slide_in":
		ready = true

func show() -> void:
	timer.start()


func _on_TimerMenuShow_timeout() -> void:
	animation_player.play("slide_in")
