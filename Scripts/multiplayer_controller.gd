extends Control

@export var address = "127.0.0.1"
@export var port = 8910
var peer


func _ready():
	multiplayer.peer_connected.connect(peer_connected)
	multiplayer.peer_disconnected.connect(peer_disconnected)
	multiplayer.connected_to_server.connect(connected_to_server)
	multiplayer.connection_failed.connect(connection_failed)
	if "--server" in OS.get_cmdline_args():
		host_game()
		

# Called only from clients
func connected_to_server():
	print("Connected To Server")
	send_player_information.rpc_id(1, $LineEdit.text, multiplayer.get_unique_id())


# Called only from clients
func connection_failed():
	print("Connection Failed")
	

@rpc("any_peer")
func send_player_information(name, id):
	if !GameManager.players.has(id):
		GameManager.players[id] = {
			"name" : name,
			"id" : id,
			"score": 0
		}
		
	if multiplayer.is_server():
		for i in GameManager.players:
			send_player_information.rpc(GameManager.players[i].name, i)


@rpc("any_peer", "call_local")
func start_game():
	var scene = load("res://Scenes/world.tscn").instantiate()
	get_tree().root.add_child(scene)
	self.hide()


# this gets called on the server and clients
func peer_connected(id):
	print("Player Connected " + str(id))

# This gets called on the server and clients
func peer_disconnected(id):
	print("Player Diconnected " + str(id))
	GameManager.players.erase(id)
	var players = get_tree().get_nodes_in_group("Player")
	for i in players:
		if i.name == str(id):
			i.queue_free()
			
func host_game():
	peer = ENetMultiplayerPeer.new()
	var error = peer.create_server(port, 2)
	if error != OK:
		print("Cannot Host: " + str(error))
		return
	peer.get_host().compress(ENetConnection.COMPRESS_RANGE_CODER)
	
	multiplayer.set_multiplayer_peer(peer)
	print("Waiting For Players")
	


func _on_host_button_down():
	host_game()
	send_player_information($LineEdit.text, multiplayer.get_unique_id())

func _on_join_button_down():
	peer = ENetMultiplayerPeer.new()
	peer.create_client(address, port)
	peer.get_host().compress(ENetConnection.COMPRESS_RANGE_CODER)
	multiplayer.set_multiplayer_peer(peer)
	pass # Replace with function body.


func _on_start_game_button_down():
	start_game.rpc()
	pass # Replace with function body.
