extends Control

@onready var main_menu = $MainMenu
@onready var adress_entry = $MainMenu/MarginContainer/VBoxContainer/AdressEntry

@export var player_scene: PackedScene

const PORT = 135

var enet_peer = ENetMultiplayerPeer.new()

func add_player(peer_id):
	var player = player_scene.instantiate()
	player.name = str(peer_id)

	find_parent("World").find_child("PlayerContainer").call_deferred("add_child", player)


func _on_host_button_pressed():
	main_menu.hide()

	enet_peer.create_server(PORT)
	multiplayer.multiplayer_peer = enet_peer
	multiplayer.peer_connected.connect(add_player)

	add_player(multiplayer.get_unique_id())


func _on_join_button_pressed():
	main_menu.hide()

	enet_peer.create_client("localhost", PORT)
	multiplayer.multiplayer_peer = enet_peer


