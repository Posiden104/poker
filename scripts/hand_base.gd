class_name HandBase
extends Control

@export var hand_container: HBoxContainer
@export var dealable: Dealable
@export var name_label: Label
@export var multiplayer_id: int

var cards: Array[Card]
var center_cards: Array[Card]

func setup():
	SIGNAL_BUS.register_player.emit(self)
	SIGNAL_BUS.center_card_dealt.connect(center_card_dealt)
	clear()

func set_name_label(label_name):
	name_label.text = label_name
	
func set_multiplayer_id(id):
	multiplayer_id = id

func clear():
	cards.clear()
	center_cards.clear()
	for child in hand_container.get_children():
		child.queue_free()

func center_card_dealt(card: Card):
	center_cards.append(card)

func card_count() -> int:
	return cards.size()

func unregister_player():
	SIGNAL_BUS.unregister_player.emit(self)

@rpc("call_local")
func deal(data):
	#print("[%d] - Deal called on base hand" % multiplayer_id)
	#print("[%d] - deal" % multiplayer_id)
	var card = GameManager.deck_manager.get_card(dict_to_inst(data))
	var c = dealable.deal(card)
	cards.append(card)
	hand_container.add_child(c)
	pass
	
#func deal_real_card(card: Card):
	#print("[%d] - Deal real card called on base hand" % multiplayer_id)
	#pass

@rpc("call_local")
func deal_down():
	#print("[%d] - Deal down called on base hand" % multiplayer_id)
	pass

func reveal(c1, c2):
	clear()
	deal(c1)
	deal(c2)
	show_hand()

func request_bet():
	return 1

func fold():
	pass

func show_hand():
	for c in hand_container.get_children():
		c.set_is_face_up(true)

func evaluate_hand(hand: Array) -> Dictionary:
	var values = hand.map(func(c): return c.value)
	values.sort()
	var suits = hand.map(func(c): return c.suit)
	
	var value_counts = {}
	for v in values:
		value_counts[v] = value_counts.get(v, 0) + 1
	
	var is_flush = suits.all(func(s): return s == suits[0])
	var is_straight = values == range(values[0], values[0] + 5) or (values == [1, 10, 11, 12, 13]) # Ace-high straight
	
	var hand_rank = {}
	
	if is_flush and is_straight:
		hand_rank = { "rank": 9, "type": "Straight Flush", "high": values[-1] }
	elif 4 in value_counts.values():
		hand_rank = { "rank": 8, "type": "Four of a Kind", "value": values[-1] }
	elif 3 in value_counts.values() and 2 in value_counts.values():
		hand_rank = { "rank": 7, "type": "Full House" }
	elif is_flush:
		hand_rank = { "rank": 6, "type": "Flush" }
	elif is_straight:
		hand_rank = { "rank": 5, "type": "Straight" }
	elif 3 in value_counts.values():
		hand_rank = { "rank": 4, "type": "Three of a Kind" }
	elif value_counts.values().count(2) == 2:
		hand_rank = { "rank": 3, "type": "Two Pair" }
	elif 2 in value_counts.values():
		hand_rank = { "rank": 2, "type": "One Pair" }
	else:
		hand_rank = { "rank": 1, "type": "High Card", "high": values[-1] }

	return hand_rank
	
