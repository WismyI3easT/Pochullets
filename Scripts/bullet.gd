extends Area2D

class_name Bullet

@export var bullet_speed = 500

func _physics_process(delta):
    global_position += Vector2(bullet_speed * delta, 0).rotated(rotation)


func _on_visible_on_screen_notifier_2d_screen_exited():
    queue_free()

