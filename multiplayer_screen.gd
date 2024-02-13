extends Control

@export var ip_address = "0.0.0.0";
#@export var port = 9818
@export var port = 8910

var max_clients = 2
var peer

# Called when the node enters the scene tree for the first time.
func _ready():
	multiplayer.peer_connected.connect(player_connected)
	multiplayer.peer_disconnected.connect(player_disconnected)
	multiplayer.connected_to_server.connect(player_connected_to_server)
	multiplayer.connection_failed.connect(player_connection_failed)
	if "--server" in OS.get_cmdline_args():
		host_game()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

@rpc("any_peer", "call_local")
func start_game():
	var scene = load("res://level_1.tscn").instantiate()
	get_tree().root.add_child(scene)
	self.hide()

@rpc("any_peer")
func send_player_info(name, id):
	if !GameManager.players.has(id):
		GameManager.players[id]={
			"name": name,
			"ID": id
		}
	
	if multiplayer.is_server():
		for i in GameManager.players:
			send_player_info.rpc(GameManager.players[i].name, i)

func player_connected(id):
	print("Player " + str(id) + " Connected")

func player_disconnected(id):
	print("Player " + str(id) + " Disconnected")
	GameManager.players.erase(id)
	var players = get_tree().get_nodes_in_group("connected_players")
	for i in players:
		if i.name == str(id):
			i.queue_free()

func player_connected_to_server():
	print("Connected to server")
	send_player_info.rpc_id(1, $name.text, multiplayer.get_unique_id())

func player_connection_failed(id):
	print("Connection failed")

func host_game():
	peer = ENetMultiplayerPeer.new()
	var error = peer.create_server(port, max_clients)
	if error != OK:
		print("Cannot Host: " + error)
		return
	
	multiplayer.set_multiplayer_peer(peer)
	print("Waiting for players to join")
	

func _on_host_button_down():
	host_game()
	send_player_info($name.text, multiplayer.get_unique_id())
	pass # Replace with function body.


func _on_join_button_down():
	peer = ENetMultiplayerPeer.new()
	ip_address = str($ip_address_to_connect.text)
	peer.create_client(ip_address, port)
	multiplayer.set_multiplayer_peer(peer)
	
	pass # Replace with function body.


func _on_start_game_button_down():
	start_game.rpc()
	pass # Replace with function body.
