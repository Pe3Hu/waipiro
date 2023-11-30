extends MarginContainer


@onready var gameboard = $VBox/Gameboard
@onready var health = $VBox/Health

var cradle = null
var arena = null
var side = null
var index = null


func set_attributes(input_: Dictionary) -> void:
	cradle = input_.cradle
	index = Global.num.index.tamer
	Global.num.index.tamer += 1
	
	var input = {}
	input.tamer = self
	gameboard.set_attributes(input)
	input.limits = {}
	input.limits.vigor = 0.25
	input.limits.standard = 0.5
	input.limits.fatigue = 0.25
	input.total = 100
	health.set_attributes(input)



func quench_hunger() -> void:
	var victims = []
	var hunters = {}
	
	for sustenance in Global.arr.sustenance:
		hunters[sustenance] = []
	
	for card in gameboard.discard.cards.get_children():
		if card.gameboard == gameboard:
			hunters[card.sustenance].append(card)
		else:
			victims.append(card)
	
	victims.sort_custom(func(a, b): return a.couple.stack.get_number() < b.couple.stack.get_number())
	
	for sustenance in hunters:
		for hunter in hunters[sustenance]:
			if victims.is_empty():
				return
			
			var victim = null
			
			match sustenance:
				"scavenger":
					victim = victims.pop_back()
				"herbivore":
					victim = victims.pop_front()
				"predator":
					victim = victims.pick_random()
					victims.erase(victim)
			
			gameboard.discard.cards.remove_child(victim)
			hunter.add_victim(victim)
	
	for victim in victims:
		gameboard.discard.cards.remove_child(victim)
