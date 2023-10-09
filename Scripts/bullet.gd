# bullet.gd
extends Area2D

class_name Bullet

@export var speed = 500
@export var damage = 25

func _physics_process(delta):
    global_position += Vector2(speed * delta, 0).rotated(rotation)

func _on_body_entered(body):
    if body.has_method("apply_damage"):
        body.apply_damage(damage)
    queue_free()
