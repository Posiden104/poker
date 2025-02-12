class_name CenterCardHand
extends HandBase

func setup():
	clear()
	
func clear():
	for child in hand_container.get_children():
		child.queue_free()
