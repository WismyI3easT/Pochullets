# playerContainer.gd
extends Node2D

@onready var player = preload("res://Scenes/player.tscn")

@onready var spawn_pos_1 = $PlayerSpawnPos1
@onready var spawn_pos_2 = $PlayerSpawnPos2

var current_player = 1

func _on_child_entered_tree(node):
	if node.is_in_group("player"):
		match current_player:
			1:
				node.global_position = spawn_pos_1.global_position
			2:
				node.global_position = spawn_pos_2.global_position

		current_player += 1

		node.bullet_shot.connect(_on_player_bullet_shot)


func _on_player_bullet_shot(bullet_scene, location, _rotation):
	var bullet = bullet_scene.instantiate()
	bullet.damage = 100
	bullet.global_position = location
	bullet.rotation = _rotation
	find_parent("World").find_child("BulletContainer").add_child(bullet)

