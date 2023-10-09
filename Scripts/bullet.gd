# bullet.gd
extends Area2D

class_name Bullet

@export var damage = 25
@export var speed = 500
@export var shooter_id = -1

func _physics_process(delta):
    global_position += Vector2(speed * delta, 0).rotated(rotation)

func _on_body_entered(body):
    if body.has_method("apply_damage") and body.get_instance_id() != shooter_id:
        body.apply_damage(damage)
        queue_free()
