class_name Dealable
extends Control

@export var show_card_face_on_deal: bool
@export var card_prefab: PackedScene

func deal(card: Card):
	var c = card_prefab.instantiate() as UICardScene
	c.card = card
	c.set_is_face_up(show_card_face_on_deal)
	return c
