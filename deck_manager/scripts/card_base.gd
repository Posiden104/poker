class_name CardBase
extends Node

@export var card: Card
@export var deck: Deck
@export var card_back: Texture2D
@export var is_face_up: bool = false
@export var card_image = TextureRect

const default_card_back = preload("res://deck_manager/resources/images/cards/cardBack_red5.png")

func _ready():
	hide_card()
	load_card()
	show_card()
	refresh_image()

func load_card():
	if deck:
		card_back = deck.card_back
	else:
		card_back = default_card_back
	

func set_is_face_up(face_up):
	is_face_up = !face_up
	flip()

func hide_card():
	card_image.visible = false

func show_card():
	card_image.visible = true

func flip():
	is_face_up = not is_face_up
	refresh_image()

func refresh_image():
	if card == null: 
		return
	if is_face_up:
		card_image.texture = card.card_image
	else:
		card_image.texture = card_back
