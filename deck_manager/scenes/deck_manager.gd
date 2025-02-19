class_name DeckManager
extends Node2D

@export var deck: Deck
@export var deck_visual: Sprite2D
@export var show_deck_visual: bool = true

func _ready():
	if not show_deck_visual:
		deck_visual.hide()
	else:
		deck_visual.texture = deck.card_back
	shuffle()

func shuffle():
	deck.shuffle()

func deal() -> Card:
	return deck.deal()

func discard(card: Card):
	deck.discard(card)

func cards_left() -> int:
	return deck.cards_left()

func get_card(card: Card):
	for c in deck.cards:
		if c.value == card.value and c.suit == card.suit:
			return c.duplicate()
