extends Area2D

var speed := 250

func _physics_process(delta: float) -> void:
	position.x -= speed * delta


func _on_VisibilityNotifier2D_viewport_exited(viewport: Viewport) -> void:
	queue_free()
