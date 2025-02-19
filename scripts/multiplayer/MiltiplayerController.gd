class_name MultiplayerScene
extends Control

@export_category("Connection Information")
@export var address := "127.0.0.1"
@export var port := 8910

@export_category("Lobby Items")
@export var host_button: Button
@export var join_button: Button
@export var start_button: Button
@export var message_box: TextEdit
@onready var host_instructions = $HostInstructions

var peer
var host_instructions_sent = false

# Called when the node enters the scene tree for the first time.
func _ready():
	multiplayer.peer_connected.connect(peer_connected)
	multiplayer.peer_disconnected.connect(player_disconnected)
	multiplayer.connected_to_server.connect(connected_to_server)
	multiplayer.connection_failed.connect(connection_failed)
	
	host_button.visible = true
	join_button.visible = true
	start_button.visible = false
	host_instructions.visible = false

# called on server and clients
func peer_connected(id):
	print("Player Connected " + str(id))

# called on server and clients
func player_disconnected(id):
	print("Player Disconnected " + str(id))

# called only on clients
func connected_to_server():
	print("Connected to Server")
	send_player_information.rpc_id(1, $LineEdit.text, multiplayer.get_unique_id())


@rpc("any_peer")
func send_player_information(name, id):
	if !GameManager.Players.has(id):
		GameManager.Players[id] = {
			"name": name,
			"id": id
		}
		add_text_to_message_box("%s joined" % name)
	
	if multiplayer.get_unique_id() == id and id != 1:
		add_text_to_message_box("Please wait for the host to start the game.")
	
	if multiplayer.get_unique_id() == 1 and !host_instructions_sent:
		add_text_to_message_box("Press \"Start Game\" when everyone has joined.")
		host_instructions_sent = true
	
	if multiplayer.is_server():
		for i in GameManager.Players:
			send_player_information.rpc(GameManager.Players[i].name, i)

# called only on clients
func connection_failed():
	print("Connection Failed")

@rpc("any_peer", "call_local")
func start_game():
	var poker = load("res://scenes/Poker.tscn").instantiate()
	get_tree().root.add_child(poker)
	self.hide()
	poker.get_child(0).start()

func add_text_to_message_box(text):
	message_box.text = "%s%s\n" % [message_box.text, text]

func _on_host_pressed():
	peer = ENetMultiplayerPeer.new()
	var error = peer.create_server(port, 8)
	if error != OK:
		print("cannot host : %d" % error)
		return
	
	peer.get_host().compress(ENetConnection.COMPRESS_RANGE_CODER)
	
	multiplayer.set_multiplayer_peer(peer)
	print("Waiting for players!")
	send_player_information($LineEdit.text, multiplayer.get_unique_id())
	host_button.visible = false
	join_button.visible = false
	start_button.visible = true
	host_instructions.visible = true

func _on_join_pressed():
	peer = ENetMultiplayerPeer.new()
	peer.create_client(address, port)
	peer.get_host().compress(ENetConnection.COMPRESS_RANGE_CODER)
	
	multiplayer.set_multiplayer_peer(peer)
	
	host_button.visible = false
	join_button.visible = false
	start_button.visible = false

func _on_start_game_pressed():
	start_game.rpc()
