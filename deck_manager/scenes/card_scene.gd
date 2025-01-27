class_name CardScene
extends Node2D

@export var card: Card
@export var deck: Deck
@export var card_back: Texture2D
@export var is_flipped: bool = false

@onready var card_image = $CardImage
const default_card_back = preload("res://deck_manager/resources/images/cards/cardBack_red5.png")

func _ready():
	hide_card()
	if deck:
		card_back = deck.card_back
	else:
		card_back = default_card_back

func set_flipped(flipped):
	is_flipped = !flipped
	flip()

func hide_card():
	card_image.hide()

func show_card():
	card_image.show()

func flip():
	is_flipped = not is_flipped
	refresh_image()

func refresh_image():
	if card == null: 
		return
	if is_flipped:
		card_image.texture = card.card_image
	else:
		card_image.texture = card_back
