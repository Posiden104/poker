class_name OpponentHand
extends HandBase




func deal(card: Card, deck: Deck):
	cards.append(card)
	var c = card_prefab.instantiate() as UICardScene
	c.card = card
	c.deck = deck
	self.add_child(c)
	c.set_is_face_up(false)
