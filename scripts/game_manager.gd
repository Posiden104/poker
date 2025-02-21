extends Node

var Players = {}

var ai_player_limit = 1000
var ai_players = 1000

var deck: Deck
var deck_manager: DeckManager

func find_player(id):
	for p in Players:
		if Players[p].id == id:
			return Players[p]

func add_ai_player():
	ai_players -= 1
	Players[ai_players] = {
		"name": "Opponent(AI) %d" % (ai_player_limit - ai_players),
		"id": ai_players
	}
	
	return Players[ai_players]
