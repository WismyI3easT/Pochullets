# mpManager.gd
extends Control

@onready var main_menu = $MainMenu
@onready var address_entry = $MainMenu/MarginContainer/VBoxContainer/AddressEntry
@onready var port_entry = $MainMenu/MarginContainer/VBoxContainer/PortEntry

@export var player_scene: PackedScene

var ip_address = "localhost"
var port = "696969"

var enet_peer = ENetMultiplayerPeer.new()

func add_player(peer_id):
	var player = player_scene.instantiate()
	player.name = str(peer_id)

	find_parent("World").find_child("PlayerContainer").call_deferred("add_child", player)


func _on_host_button_pressed():
	main_menu.hide()

	enet_peer.create_server(port)
	multiplayer.multiplayer_peer = enet_peer
	multiplayer.peer_connected.connect(add_player)

	add_player(multiplayer.get_unique_id())


func _on_join_button_pressed():
	main_menu.hide()

	if !address_entry.text.is_empty():
		ip_address = address_entry.text

	if !port_entry.text.is_empty():
		port = port_entry.text

	enet_peer.create_client(ip_address, port)
	multiplayer.multiplayer_peer = enet_peer

