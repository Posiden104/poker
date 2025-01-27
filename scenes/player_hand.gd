class_name PlayerHand
extends Node2D

@export var card1: CardScene
@export var card2: CardScene

var number_of_cards: int = 0

func _ready():
	card1.hide_card()
	card2.hide_card()

func deal(card: Card):
	number_of_cards += 1
	if number_of_cards == 1:
		card1.card = card
		card1.show_card()
		card1.set_flipped(true)
	else:
		card2.card = card
		card2.show_card()
		card2.set_flipped(true)
