extends MarginContainer


@onready var tamers = $VBox/Tamers
@onready var libra = $VBox/Libra
@onready var lair = $VBox/Lair
@onready var turn = $VBox/Counters/Turn
@onready var cycle = $VBox/Counters/Cycle
@onready var timer = $Timer

var battleground = null
var left = null
var right = null
var winner = null
var loser = null
var hunger = true


func set_attributes(input_: Dictionary) -> void:
	battleground  = input_.battleground
	
	var input = {}
	input.arena = self
	libra.set_attributes(input)
	lair.set_attributes(input)
	
	for tamer in input_.tamers:
		add_tamer(tamer)
	
	init_counters()
	next_cycle()
	
	#for _i in 14:
	while winner == null:
		next_turn()
	
	lair.award()


func add_tamer(tamer_: MarginContainer) -> void:
	tamer_.cradle.tamers.remove_child(tamer_)
	tamers.add_child(tamer_)
	tamer_.arena = self
	
	if tamers.get_child_count() == 1:
		left = tamer_
		tamer_.side = "left"
		tamers.move_child(tamer_, 0)
	else:
		right = tamer_
		tamer_.side = "right"
		left.opponent = tamer_
		tamer_.opponent = left
	
	for blood in Global.arr.blood:
		tamer_.bloods[blood] = false


func init_counters() -> void:
	var input = {}
	input.proprietor = self
	input.type = "counter"
	
	for subtype in Global.arr.counter:
		input.subtype = subtype
		input.value = 0
		var counter = get(subtype)
		counter.set_attributes(input)
		counter.set_title_size(Vector2(Global.vec.size.prestige))


func next_turn() -> void:
	turn.stack.change_number(1)
	
	if winner == null:
		libra.reset_icons()
		
		for side in Global.arr.side:
			var tamer = get(side)
			
			for _i in libra.capacity:
				var beast = tamer.domain.dormant.pull_beast()
				tamer.source.update_couple_based_on_beast(beast)
				libra.add_beast(side, beast)
		
		libra.set_achievements("start")
		libra.set_previous()
		libra.set_achievements("end")
		
		if libra.comparison.subtype != "equal" and libra.comparison.subtype != "similar":
			var damage = libra.get_damage()
			match libra.comparison.subtype:
				"greater":
					libra.previous.left = "victory"
					libra.previous.right = "defeat"
				"less":
					libra.previous.right = "victory"
					libra.previous.left = "defeat"
			
			for side in Global.arr.side:
				var tamer = get(side)
				
				match libra.previous[side]:
					"victory":
						libra.give_beasts_to_tamer(tamer)
					"defeat":
						tamer.health.get_damage(damage)
			
			for side in Global.arr.side:
				var tamer = get(side)
				
				match libra.previous[side]:
					"defeat":
						for blood in Global.arr.blood:
							if tamer.bloods[blood]:
								var beast = tamer.opponent.domain.hunter.beasts.get_children().back()
								var data = {}
								data.type = "fight"
								data.subtype = blood
								data.condition = "victory"
								beast.chronicle.update_achievement(data)
					"victory":
						for _side in Global.arr.side:
							var beast = tamer.domain.hunter.beasts.get_children().back()
							
							if side == _side:
								beast.rise_rating(damage)
							else:
								beast = tamer.domain.prey.beasts.get_children().back()
							
							var data = {}
							data.type = "impulse"
							data.subtype = "current"
							data.condition = libra.previous[_side]
							beast.chronicle.update_achievement(data)
		
		if hunger:
			for side in Global.arr.side:
				var tamer = get(side) 
				tamer.domain.quench_hunger()
			
			next_cycle()
	else:
		lair.award()
		timer.stop()


func next_cycle() -> void:
	turn.stack.set_number(0)
	cycle.stack.change_number(1)
	
	for side in Global.arr.side:
		var tamer = get(side)
		tamer.domain.dormant.reshuffle()
	
	hunger = false
	next_turn()


func _on_timer_timeout():
	next_turn()


func set_loser(tamer_: MarginContainer) -> void:
	if winner == null:
		for side in Global.arr.side:
			var tamer = get(side)
			
			if tamer != tamer_:
				winner = tamer
			else:
				loser = tamer
