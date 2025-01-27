class_name PokerManager
extends Node2D

@export var deck_manager: DeckManager
@export var player_hand: Node2D


func _on_deal_button_pressed():
	var c1 = deck_manager.deal()
	player_hand.deal(c1)
