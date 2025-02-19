class_name OpponentHand
extends HandBase

@rpc("call_local")
func deal_down():
	var c = dealable.deal(Card.new())
	hand_container.add_child(c)
