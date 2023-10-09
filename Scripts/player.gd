# player.gd
extends CharacterBody2D

class_name Player


@onready var muzzle = $Body/Gun/Muzzle

@onready var stats = {
	"health": 100,
	"move_speed": 200,
	"rotation_speed": 4,
	"fire_rate": 0.5,
	"bullet_speed": 500,
	"bullet_damage": 25,
}

var bullet_scene = preload("res://Scenes/bullet.tscn")

var shoot_cd := false


func _enter_tree():
	set_multiplayer_authority(name.to_int())


func _ready():
	if !is_multiplayer_authority(): return

	# camera.current = true
	# Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


func _physics_process(delta):
	if !is_multiplayer_authority(): return

	var direction = Input.get_vector("left", "right", "up", "down").normalized()
	velocity = direction * stats.move_speed * delta * 50

	if direction != Vector2.ZERO:
		var desired_rotation = rad_to_deg(direction.angle())
		var delta_rotation = fmod(desired_rotation - rotation_degrees + 360.0, 360.0) - 180.0
		rotation_degrees += delta_rotation * stats.rotation_speed * delta

	if Input.is_action_pressed("shoot"):
		if !shoot_cd:
			shoot_cd = true
			shoot.rpc()
			await get_tree().create_timer(stats.fire_rate).timeout
			shoot_cd = false

	move_and_slide()
	$Body/Gun.look_at(get_global_mouse_position())

@rpc("call_local")
func shoot():
	var bullet = bullet_scene.instantiate()
	bullet.shooter_id = get_instance_id()
	bullet.damage = stats.bullet_damage
	bullet.speed = stats.bullet_speed
	get_parent().add_child(bullet)
	bullet.global_position = $Body/Gun/Muzzle.global_position
	bullet.rotation = $Body/Gun.global_rotation


func apply_damage(damage):
	stats.health -= damage
	if stats.health <= 0:
		queue_free()
