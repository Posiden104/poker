class_name CardScene
extends Node2D

@export var card: Card
@export var is_flipped: bool = false

@onready var card_image = $CardImage
@onready var card_back = preload("res://resources/images/PNG/Cards/cardBack_red5.png")

func set_flipped(flipped):
	is_flipped = !flipped
	flip()

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
