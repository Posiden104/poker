class_name DeckExample
extends Node2D

@export var deck_manager: DeckManager
@export var cards_left_counter: Label
@export var flip_button: Button
@export var card: CardScene

func _ready():
	pass
	
func shuffle():
	card.hide_card()
	deck_manager.shuffle()
	if flip_button: flip_button.disabled = true
	if cards_left_counter: cards_left_counter.text = str(deck_manager.cards_left())

func _on_flip_button_pressed():
	card.flip()

func _on_next_button_pressed():
	deal()

func _on_shuffle_button_pressed():
	shuffle()

func deal():
	if flip_button: flip_button.disabled = false
	card.set_flipped(false)
	deck_manager.discard(card.card)
	card.card = deck_manager.deal()
	card.refresh_image()
	cards_left_counter.text = str(deck_manager.cards_left())

func _on_deal_button_pressed():
	deal()
	card.set_flipped(true)
	card.show_card()
