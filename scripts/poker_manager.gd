class_name PokerManager
extends Node2D

@export var deck_manager: DeckManager
@export var player_hand: PlayerHand
@export var opponent_manager: OpponentManager
@export var start_button: Button
@export var add_oppt_button: Button
@export var step_button: Button

var player_hand_limit = 2
var deal_to_player = true

enum States {HAND_SETUP, SHUFFLE, DEALING, FIRST_BET, FLOP, FLOP_BET, TURN, TURN_BET, RIVER, RIVER_BET, CLEANUP}
var state: States = States.HAND_SETUP

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

func _on_start_button_pressed():
	deck_manager.shuffle()
	step()
	step_button.disabled = false

func _on_deal_button_pressed():
	if deal_to_player:
		deal_to_player = false
		if player_hand.card_count() < player_hand_limit:
			var c1 = deck_manager.deal()
			player_hand.deal(c1, deck_manager.deck)
	else:
		deal_to_player = opponent_manager.deal_opponent(deck_manager.deal(), deck_manager.deck)
	
	if deal_to_player and player_hand.card_count() == player_hand_limit:
		step()


func _on_step_button_pressed():
	_on_deal_button_pressed()
