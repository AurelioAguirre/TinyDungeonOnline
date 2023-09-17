extends Node2D

var multiplayer_peer = ENetMultiplayerPeer.new()

@onready var ip_address = $Menu/MenuPanel/VBoxContainer/HBoxContainer/Address.text
@onready var open_port = $Menu/MenuPanel/VBoxContainer/HBoxContainer/Port.text.to_int()
@onready var player_info = $Menu.menu_dict

@onready var menu = $Menu
@onready var world = $World

var connected_players = {1:player_info}
var local_player_character

func _ready():
	$MessageInput.visible = false

func _on_host_pressed():
	multiplayer_peer.create_server(open_port)
	multiplayer.multiplayer_peer = multiplayer_peer
	menu.visible = false
	world.visible = true
	$MessageInput.visible = true
	add_player_character(1, player_info)
	multiplayer_peer.peer_connected.connect(on_connect_to_server)
	
func _on_join_pressed():
	multiplayer_peer.create_client(ip_address, open_port)
	multiplayer.multiplayer_peer = multiplayer_peer
	menu.visible = false
	world.visible = true
	$MessageInput.visible = true

func add_player_character(peer_id, player_data):
	var player_character = preload("res://player.tscn").instantiate()
	print("adding player: ", peer_id)
	player_character.name = str(peer_id)
	if player_data["gender"] == "male":
		player_character.image_path = player_data["male_image_path"]
	else:
		player_character.image_path = player_data["female_image_path"]
	player_character.set_the_player_image()
	world.add_child(player_character)
		
func _on_message_input_text_submitted(new_text):
	local_player_character.rpc("display_chat_message", new_text)
	$MessageInput.text = ""
	$MessageInput.release_focus()

func on_connect_to_server(new_peer_id):
	print("On connect to server")
	rpc_id(new_peer_id, "client_passthrough", new_peer_id)

@rpc
func client_passthrough(peer_id):
	print("client passthrough")
	rpc_id(1, "add_player_data", player_info)

@rpc
func add_player_data(player_info):
	print("add player data!")
	var peer_id = multiplayer.get_remote_sender_id()
	connected_players[peer_id] = player_info
	await get_tree().create_timer(1).timeout
	add_player_character(peer_id, player_info)
	
func _on_multiplayer_spawner_spawned(node):
	pass
