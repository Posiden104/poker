class_name PlayerHand
extends HandBase


@rpc("any_peer", "call_local")
func deal(data):
	print("player deal")
	var card = dict_to_inst(data)
	print("%d dealt card value %d" % [multiplayer.get_unique_id(), card.value])
	var c = dealable.deal(card)
	cards.append(card)
	hand_container.add_child(c)

@rpc("any_peer", "call_local")
func deal_down(_data):
	pass
