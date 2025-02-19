class_name CenterCardHand
extends HandBase

func setup():
	clear()
	
func clear():
	for child in hand_container.get_children():
		child.queue_free()

@rpc("call_local")
func deal(data):
	#print("[%d] - deal" % multiplayer_id)
	var card = GameManager.deck_manager.get_card(dict_to_inst(data))
	var c = dealable.deal(card)
	cards.append(card)
	hand_container.add_child(c)
