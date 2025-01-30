class_name HandBase
extends Control

@export var card_prefab: PackedScene

var cards: Array[Card]

func _ready():
	for child in self.get_children():
		child.queue_free()

func card_count() -> int:
	return cards.size()

func deal(card: Card, deck: Deck):
	cards.append(card)
	var c = card_prefab.instantiate() as UICardScene
	c.card = card
	c.deck = deck
	self.add_child(c)
	c.set_is_face_up(true)
	

