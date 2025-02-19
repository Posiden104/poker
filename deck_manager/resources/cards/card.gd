class_name Card
extends Resource

@export var card_name: String
@export var suit: enums.Suit
@export var value: int
@export var card_image: Texture2D

static func load_from_dict(dict):
	var card = Card.new()
	card.card_name = dict["card_name"]
	card.suit = dict["suit"]
	card.value = dict["value"]
	card.card_image = dict["card_image"]
	return card
