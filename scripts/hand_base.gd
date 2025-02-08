class_name HandBase
extends Control

@export var hand_container: HBoxContainer
@export var dealable: Dealable

var cards: Array[Card]
var id: int = -1

func setup():
	SIGNAL_BUS.register_player.emit(self)
	for child in hand_container.get_children():
		child.queue_free()

func set_id(_id):
	id = _id

func card_count() -> int:
	return cards.size()

func unregister_player():
	SIGNAL_BUS.unregister_player.emit(self)

func deal(card: Card, deck: Deck):
	var c = dealable.deal(card, deck)
	cards.append(card)
	hand_container.add_child(c)

func request_bet():
	return 1
