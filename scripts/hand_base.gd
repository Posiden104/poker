class_name HandBase
extends Control

@export var hand_container: HBoxContainer
@export var dealable: Dealable
@export var name_label: Label
@export var multiplayer_id: int

var cards: Array[Card]

func setup():
	SIGNAL_BUS.register_player.emit(self)
	clear()

func set_name_label(label_name):
	name_label.text = label_name
	
func set_multiplayer_id(id):
	multiplayer_id = id

func clear():
	for child in hand_container.get_children():
		child.queue_free()

func card_count() -> int:
	return cards.size()

func unregister_player():
	SIGNAL_BUS.unregister_player.emit(self)

@rpc("call_local")
func deal(_data):
	#print("[%d] - Deal called on base hand" % multiplayer_id)
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
