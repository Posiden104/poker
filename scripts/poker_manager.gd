class_name PokerManager
extends Node2D

@export_category("Managers")
@export var deck_manager: DeckManager
@export var opponent_manager: OpponentManager
@export var deal_timer: Timer

@export_category("UI")
@export var start_button: Button
@export var add_oppt_button: Button
@export var step_button: Button
@export var state_label: Label
@export var center_cards: CenterCardHand
@export var poker_canvas: CanvasLayer

@export_category("Players")
@export var local_player: HandBase

var hand_limit = 2

var players: Array[HandBase]
#var server_players: Array[ServerPlayer]
var active_player_pointer: int = 0
var rounds_dealt = 0
var deal_target = 0
var down_card_dict = inst_to_dict(Card.new())


enum State {HAND_SETUP, SHUFFLE, DEALING, FIRST_BET, FLOP, FLOP_BET, TURN, TURN_BET, RIVER, RIVER_BET, REVEAL, CLEANUP}
var state: State = State.HAND_SETUP

func _ready():
	SIGNAL_BUS.register_player.connect(register_player)
	SIGNAL_BUS.unregister_player.connect(unregister_player)
	GameManager.deck = deck_manager.deck
	GameManager.deck_manager = deck_manager
	if not multiplayer.is_server():
		step_button.visible = false
		start_button.visible = false
		add_oppt_button.visible = false

func start():
	poker_canvas.visible = true
	state_label.text = "Hand setup"
	step_button.visible = false
	center_cards.setup()
	for i in GameManager.Players:
		var player = GameManager.Players[i]
		if player.id == multiplayer.get_unique_id():
			local_player.set_name_label(player.name)
			local_player.setup()
			local_player.set_multiplayer_id(player.id)
		else:
			opponent_manager.add_opponent(player.name, player.id)

@rpc("call_local")
func step():
	step_button.disabled = true
	step_button.visible = false
	
	state = (int(state) + 1) as State
	if state > State.CLEANUP:
		state = 0
		
	match state:
		State.HAND_SETUP:
			step.rpc()
		State.SHUFFLE:
			state_label.text = "shuffle"
			shuffle()
		State.DEALING:
			state_label.text = "dealing"
			deal_hands()
		State.FIRST_BET:
			state_label.text = "first bet"
			bet()
		State.FLOP:
			state_label.text = "flop"
			deal(3)
		State.FLOP_BET:
			state_label.text = "flop bet"
			bet()
		State.TURN:
			state_label.text = "turn"
			deal(1)
		State.TURN_BET:
			state_label.text = "turn bet"
			bet()
		State.RIVER:
			state_label.text = "river"
			deal(1)
		State.RIVER_BET:
			state_label.text = "river bet"
			bet()
		State.REVEAL:
			state_label.text = "reveal"
			reveal()
		State.CLEANUP:
			state_label.text = "cleanup"
			cleanup()
			if multiplayer.is_server():
				add_oppt_button.visible = true
				start_button.visible = true

func register_player(player_hand: HandBase):
	players.append(player_hand)
	#player_hand.set_id(players.size() - 1)
	
	#if multiplayer.is_server():
		#var sp = ServerPlayer.new()
		#sp.multiplayer_id = player_hand.multiplayer_id
		#server_players.append(sp)

func unregister_player(player_hand: HandBase):
	players.erase(player_hand)
	#for i in players.size():
		#if players[i].id == player_hand.id:
			#players.remove_at(i)

func shuffle():
	if not multiplayer.is_server(): return
	add_oppt_button.visible = false
	deck_manager.shuffle()
	step.rpc()

func deal_hands():
	if not multiplayer.is_server(): return
	if not deal_timer.timeout.is_connected(deal_hands):
		deal_timer.timeout.connect(deal_hands)
	var c: Card = deck_manager.deal()
	var active_player = players[active_player_pointer]
	#var server_player = server_players[active_player_pointer]
	var p = GameManager.find_player(active_player.multiplayer_id)
	p.cards.append(c)
	
	var data = inst_to_dict(c)
	local_player.deal.rpc_id(active_player.multiplayer_id, data)
	active_player.deal_down.rpc()
	#server_player.cards.append(c)
	
	active_player_pointer += 1
	
	if active_player_pointer >= players.size():
		rounds_dealt += 1
		active_player_pointer = 0
	
	if rounds_dealt == hand_limit:
		deal_timer.stop()
		deal_timer.timeout.disconnect(deal_hands)
		step.rpc()
	else:
		deal_timer.start()

func bet():
	if not multiplayer.is_server(): return
	step_button.disabled = false
	step_button.visible = true

func deal(number_of_cards):
	if not multiplayer.is_server(): return
	var c = deck_manager.deal()
	deck_manager.discard(c)
	deal_target = number_of_cards
	deal_timer.timeout.connect(deal_center)
	deal_center()

func deal_center():
	if not multiplayer.is_server(): return
	var c = deck_manager.deal()
	center_cards.deal.rpc(inst_to_dict(c))
	deal_target -= 1
	if deal_target == 0:
		deal_timer.stop()
		deal_timer.timeout.disconnect(deal_center)
		step.rpc()
		return
	deal_timer.start()

func reveal():
	if not multiplayer.is_server(): return
	for i in players.size():
		var p = players[i]
		var sp = GameManager.find_player(p.multiplayer_id)
		var c1 = inst_to_dict(sp.cards[0])
		var c2 = inst_to_dict(sp.cards[1])
		reveal_player.rpc(p.multiplayer_id, c1, c2)
		
	step_button.visible = true
	step_button.disabled = false

@rpc("call_local")
func reveal_player(id, c1, c2):
	for p in players:
		if p.multiplayer_id == id:
			p.reveal(c1, c2)

func cleanup():
	for c in center_cards.cards:
		deck_manager.discard(c)
	center_cards.cards.clear()
	center_cards.clear()
	
	for p in players:
		for c in p.cards:
			deck_manager.discard(c)
		p.clear()
	
	for sp in GameManager.Players:
		sp.cards.clear()
	
	rounds_dealt = 0
	

func _on_start_button_pressed():
	start_button.visible = false
	step.rpc()

func _on_step_button_pressed():
	step.rpc()

