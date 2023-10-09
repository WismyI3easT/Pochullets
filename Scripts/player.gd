extends CharacterBody2D

class_name Player

signal bullet_shot(bullet_scene, location, rotation)

@onready var muzzle = $Body/Gun/Muzzle

@onready var stats = {
	"health": 100,
	"move_speed": 200,
	"rotation_speed": 4,
	"fire_rate": 0.5,
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
	bullet_shot.emit(bullet_scene, muzzle.global_position, $Body/Gun.global_rotation)

