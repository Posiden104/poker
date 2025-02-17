class_name HandBase
extends Control

@export var hand_container: HBoxContainer
@export var dealable: Dealable
@export var name_label: Label
@export var multiplayer_id: int

var cards: Array[Card]
var id: int = -1

func setup():
	SIGNAL_BUS.register_player.emit(self)
	clear()

func set_name_label(label_name):
	name_label.text = label_name
	
func set_player_id(id):
	multiplayer_id = id

func clear():
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

func fold():
	pass

func show_hand():
	for c in hand_container.get_children():
		c.set_is_face_up(true)
