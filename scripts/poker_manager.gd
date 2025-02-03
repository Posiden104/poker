class_name PokerManager
extends Node2D

@export var deck_manager: DeckManager
@export var opponent_manager: OpponentManager
@export var start_button: Button
@export var add_oppt_button: Button
@export var step_button: Button

@onready var deal_timer = $DealTimer

var hand_limit = 2

var players: Array[HandBase]
var active_player_pointer: int = 0
var rounds_dealt = 0

enum States {HAND_SETUP, SHUFFLE, DEALING, FIRST_BET, FLOP, FLOP_BET, TURN, TURN_BET, RIVER, RIVER_BET, CLEANUP}
var state: States = States.HAND_SETUP

func _ready():
	SIGNAL_BUS.register_player.connect(register_player)

func step():
	match state:
		States.HAND_SETUP:
			add_oppt_button.disabled = true
			state = States.SHUFFLE
		States.SHUFFLE:
			state = States.DEALING
		States.DEALING:
			print("deal finished")
			pass
		States.FIRST_BET:
			pass
		States.FLOP:
			pass
		States.FLOP_BET:
			pass
		States.TURN:
			pass
		States.TURN_BET:
			pass
		States.RIVER:
			pass
		States.RIVER_BET:
			pass
		States.CLEANUP:
			add_oppt_button.disabled = false

func deal():
	var c = deck_manager.deal()
	players[active_player_pointer].deal(c, deck_manager.deck)
	
	active_player_pointer += 1
	
	if active_player_pointer >= players.size():
		rounds_dealt += 1
		active_player_pointer = 0
	
	if rounds_dealt == hand_limit:
		step()
	
	deal_timer.start()

func register_player(player_hand: HandBase):
	players.append(player_hand)

func _on_start_button_pressed():
	deck_manager.shuffle()
	step()
	step_button.disabled = false

func _on_deal_button_pressed():
	pass

func _on_step_button_pressed():
	deal()

func _on_deal_timer_timeout():
	deal()
