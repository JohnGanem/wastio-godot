extends Node

func _ready():
	# Connect multiplayer events
	multiplayer.peer_connected.connect(_on_peer_connected)
	multiplayer.peer_disconnected.connect(_on_peer_disconnected)
	multiplayer.connected_to_server.connect(_on_connected_to_server)
	multiplayer.connection_failed.connect(_on_connection_failed)

# HOST: Call this function to start as a server
func host_game(port := 12345):
	var peer = ENetMultiplayerPeer.new()
	var error = peer.create_server(port)
	if error != OK:
		print("Failed to host game.")
		return
	multiplayer.multiplayer_peer = peer
	print("Hosting game on port ", port)

# CLIENT: Call this function to connect to a host
func join_game(ip: String, port := 12345):
	var peer = ENetMultiplayerPeer.new()
	var error = peer.create_client(ip, port)
	if error != OK:
		print("Failed to connect.")
		return
	multiplayer.multiplayer_peer = peer
	print("Connecting to ", ip, ":", port)

# Signals
func _on_peer_connected(id):
	print("Peer connected: ", id)

func _on_peer_disconnected(id):
	print("Peer disconnected: ", id)

func _on_connected_to_server():
	print("Connected to server.")

func _on_connection_failed():
	print("Failed to connect to server.")
