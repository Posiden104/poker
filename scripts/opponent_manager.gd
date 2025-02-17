class_name OpponentManager
extends Node2D

@export var OpponentScene: PackedScene
@export var opponent_hbox: HBoxContainer
@onready var poker_manager = $"../PokerManager"

var opponents: Array[OpponentHand]
var next_opponent_id = 0

func _ready():
	print("removing all opponents")
	for c in opponent_hbox.get_children():
		#c.unregister_player()
		c.queue_free()

func add_opponent(opponent_name, opponent_id):
	var o = OpponentScene.instantiate()
	opponent_hbox.add_child(o)
	opponents.push_back(o)
	o.set_name_label(opponent_name)
	o.set_player_id(opponent_id)
	o.setup()


# Returns true if there are more opponents to deal
func deal_opponent(card: Card, deck: Deck) -> bool:
	if next_opponent_id > opponents.size() - 1:
		return true
	opponents[next_opponent_id].deal(card, deck)
	next_opponent_id += 1
	if next_opponent_id > opponents.size() - 1:
		next_opponent_id = 0
		return true
	return false


func _on_add_oppt_button_pressed():
	var oppt = GameManager.add_ai_player()
	add_opponent(oppt.name, oppt.id)
