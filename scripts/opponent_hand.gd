class_name OpponentHand
extends HandBase

@rpc("any_peer", "call_local")
func deal_down(data):
	print("%d opponent deal down" % multiplayer.get_unique_id())
	var card = dict_to_inst(data)
	var c = dealable.deal(card)
	cards.append(card)
	hand_container.add_child(c)

@rpc("any_peer", "call_local")
func deal(_data):
	pass

