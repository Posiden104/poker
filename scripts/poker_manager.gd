class_name PokerManager
extends Node2D

@export var deck_manager: DeckManager
@export var opponent_manager: OpponentManager
@export var start_button: Button
@export var add_oppt_button: Button
@export var step_button: Button
@export var center_cards: CenterCardHand

@onready var deal_timer = $DealTimer
@onready var state_label = $"../CanvasLayer/StateLabel"

var hand_limit = 2

var players: Array[HandBase]
var active_player_pointer: int = 0
var rounds_dealt = 0
var deal_target = 0

enum States {HAND_SETUP, SHUFFLE, DEALING, FIRST_BET, FLOP, FLOP_BET, TURN, TURN_BET, RIVER, RIVER_BET, REVEAL, CLEANUP}
var state: States = States.HAND_SETUP

func _ready():
	SIGNAL_BUS.register_player.connect(register_player)
	SIGNAL_BUS.unregister_player.connect(unregister_player)
	state_label.text = "Hand setup"
	step_button.visible = false
	center_cards.setup()

func step():
	step_button.disabled = true
	step_button.visible = false
	
	state += 1
	if state > States.CLEANUP:
		state = 0
		
	match state:
		States.HAND_SETUP:
			step()
		States.SHUFFLE:
			state_label.text = "shuffle"
			shuffle()
		States.DEALING:
			state_label.text = "dealing"
			deal_hands()
		States.FIRST_BET:
			state_label.text = "first bet"
			bet()
		States.FLOP:
			state_label.text = "flop"
			deal(3)
		States.FLOP_BET:
			state_label.text = "flop bet"
			bet()
		States.TURN:
			state_label.text = "turn"
			deal(1)
		States.TURN_BET:
			state_label.text = "turn bet"
			bet()
		States.RIVER:
			state_label.text = "river"
			deal(1)
		States.RIVER_BET:
			state_label.text = "river bet"
			bet()
#make sure this gets in there
		States.REVEAL:
			state_label.text = "reveal"
			reveal()
		States.CLEANUP:
			state_label.text = "cleanup"
			add_oppt_button.visible = true
			start_button.visible = true
			cleanup()

func register_player(player_hand: HandBase):
	print("player registered")
	players.append(player_hand)
	player_hand.set_id(players.size() - 1)

func unregister_player(player_hand: HandBase):
	for i in players.size():
		if players[i].id == player_hand.id:
			players.remove_at(i)

func shuffle():
	add_oppt_button.visible = false
	deck_manager.shuffle()
	step()

func deal_hands():
	deal_timer.timeout.connect(deal_hands)
	var c = deck_manager.deal()
	players[active_player_pointer].deal(c, deck_manager.deck)
	
	active_player_pointer += 1
	
	if active_player_pointer >= players.size():
		rounds_dealt += 1
		active_player_pointer = 0
	
	if rounds_dealt == hand_limit:
		deal_timer.stop()
		deal_timer.timeout.disconnect(deal_hands)
		step()
	else:
		deal_timer.start()

func bet():
	step_button.disabled = false
	step_button.visible = true

func deal(number_of_cards):
	var c = deck_manager.deal()
	deck_manager.discard(c)
	deal_target = number_of_cards
	deal_timer.timeout.connect(deal_center)
	deal_center()

func deal_center():
	var c = deck_manager.deal()
	center_cards.deal(c, deck_manager.deck)
	deal_target -= 1
	if deal_target == 0:
		deal_timer.stop()
		deal_timer.timeout.disconnect(deal_center)
		step()
		return
	deal_timer.start()

func reveal():
	for p in players:
		p.show_hand()
		
	step_button.visible = true
	step_button.disabled = false

func cleanup():
	for c in center_cards.cards:
		deck_manager.discard(c)
	center_cards.cards.clear()
	center_cards.clear()
	
	for p in players:
		for c in p.cards:
			deck_manager.discard(c)
		p.clear()
		
	rounds_dealt = 0
	

func _on_start_button_pressed():
	start_button.visible = false
	step()

func _on_step_button_pressed():
	step()

