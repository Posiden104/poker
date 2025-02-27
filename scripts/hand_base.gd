class_name HandBase
extends Control

@export var hand_container: HBoxContainer
@export var dealable: Dealable
@export var name_label: Label
@export var multiplayer_id: int
@export var best_hand_label: Label

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

func clear(clear_center = true):
	best_hand_label.text = ""
	cards.clear()
	if clear_center: 
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
	clear(false)
	deal(c1)
	deal(c2)
	show_hand()
	eval_hand()

func request_bet():
	return 1

func fold():
	pass

func show_hand():
	for c in hand_container.get_children():
		c.set_is_face_up(true)

func eval_hand():
	var best_hand = best_poker_hand()
	best_hand_label.text = "Best Hand: %s" % best_hand

func get_combinations(cards: Array, k: int) -> Array:
	var result = []
	_backtrack_combinations(cards, k, 0, [], result)
	return result

func _backtrack_combinations(cards: Array, k: int, start: int, combo: Array, result: Array) -> void:
	if combo.size() == k:
		result.append(combo.duplicate())
		return
	
	for i in range(start, cards.size()):
		combo.append(cards[i])
		_backtrack_combinations(cards, k, i + 1, combo, result)
		combo.pop_back()

func best_poker_hand() -> Dictionary:
	var all_cards = cards + center_cards
	var best_hand = { "rank": 0 } # Default to worst hand
	
	print("%d : %d" % [multiplayer_id, all_cards.size()])
	
	for hand in get_combinations(all_cards, 5):
		var hand_rank = evaluate_hand(hand)
		if hand_rank["rank"] > best_hand["rank"]:
			best_hand = hand_rank
		
	return best_hand

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
		hand_rank = { "rank": 7, "type": "Full House"}
	elif is_flush:
		hand_rank = { "rank": 6, "type": "Flush", "high": values[-1]}
	elif is_straight:
		hand_rank = { "rank": 5, "type": "Straight", "high": values[-1] }
	elif 3 in value_counts.values():
		var value = 0
		for v in value_counts:
			if value_counts[v] == 3:
				value = v
		hand_rank = { "rank": 4, "type": "Three of a Kind", "value": value }
	elif value_counts.values().count(2) == 2:
		var value = 0
		for v in value_counts:
			if value_counts[v] == 2:
				value = v
		hand_rank = { "rank": 3, "type": "Two Pair", "value": value }
	elif 2 in value_counts.values():
		var value = 0
		for v in value_counts:
			if value_counts[v] == 2:
				value = v
		hand_rank = { "rank": 2, "type": "One Pair", "value": value }
	else:
		hand_rank = { "rank": 1, "type": "High Card", "high": values[-1] }

	return hand_rank
	
