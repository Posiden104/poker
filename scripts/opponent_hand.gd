class_name OpponentHand
extends HandBase

@export var hand_container: HBoxContainer
@export var name_label: Label

func setup(name):
	name_label.text = name

func _ready():
	for child in hand_container.get_children():
		child.queue_free()

func deal(card: Card, deck: Deck):
	cards.append(card)
	var c = card_prefab.instantiate() as UICardScene
	c.card = card
	c.deck = deck
	hand_container.add_child(c)
	c.set_is_face_up(false)
