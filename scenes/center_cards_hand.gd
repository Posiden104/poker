class_name CenterCardHand
extends HandBase

func setup():
	for child in hand_container.get_children():
		child.queue_free()
