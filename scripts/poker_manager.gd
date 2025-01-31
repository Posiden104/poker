class_name PokerManager
extends Node2D

@export var deck_manager: DeckManager
@export var player_hand: PlayerHand
@export var opponent_manager: OpponentManager

var player_hand_limit = 2
var deal_to_player = true


func _on_deal_button_pressed():
	if deal_to_player:
		deal_to_player = false
		if player_hand.card_count() < player_hand_limit:
			var c1 = deck_manager.deal()
			player_hand.deal(c1, deck_manager.deck)
	else:
		deal_to_player = opponent_manager.deal_opponent(deck_manager.deal(), deck_manager.deck)
	
	if deal_to_player and player_hand.card_count() == player_hand_limit:
		$"../CanvasLayer/DealButton".disabled = true


func _on_add_oppt_button_pressed():
	opponent_manager.add_opponent()
