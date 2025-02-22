class_name PlayerHand
extends HandBase


@rpc("call_local")
func deal(data):
	super.deal(data)
	return
	##print("[%d] - deal" % multiplayer_id)
	#var card = GameManager.deck_manager.get_card(dict_to_inst(data))
	#var c = dealable.deal(card)
	#cards.append(card)
	#hand_container.add_child(c)
	
#func deal_real_card(card: Card):
	#print("[%d] - dealt card value %d" % [multiplayer.get_unique_id(), card.value])
	#var c = dealable.deal(card)
	#cards.append(card)
	#hand_container.add_child(c)

