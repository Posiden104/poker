class_name Deck
extends Resource

@export var cards: Array[Card]
@export var card_back: Texture2D

var draw_pile: Array[Card]
var discard_pile: Array[Card]

func shuffle():
	draw_pile = []
	discard_pile = []
	draw_pile = cards.duplicate(true)
	randomize()
	draw_pile.shuffle()

func deal():
	return draw_pile.pop_front()

func discard(card: Card):
	discard_pile.push_front(card)

func cards_left():
	return draw_pile.size()
