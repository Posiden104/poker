extends Node2D

@export var deck: Deck
@onready var card = $"../Card"
@onready var cards_left_counter = $"../Cards Left Counter"
@onready var flip_button = $"../Flip Button"

func _ready():
	shuffle()

func shuffle():
	card.set_flipped(false)
	flip_button.disabled = true
	deck.shuffle()
	cards_left_counter.text = str(deck.cards_left())

func _on_flip_button_pressed():
	card.flip()

func _on_next_button_pressed():
	deal()

func deal():
	flip_button.disabled = false
	card.set_flipped(false)
	deck.discard(card.card)
	card.card = deck.deal()
	card.refresh_image()
	cards_left_counter.text = str(deck.cards_left())

func _on_shuffle_button_pressed():
	shuffle()


func _on_deal_button_pressed():
	deal()
	card.set_flipped(true)
