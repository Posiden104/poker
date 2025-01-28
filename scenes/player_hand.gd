class_name PlayerHand
extends Node2D

@export var card1: CardScene
@export var card2: CardScene

var cards: Array[Card]

func _ready():
	card1.hide_card()
	card2.hide_card()

func deal(card: Card):
	cards.append(card)
