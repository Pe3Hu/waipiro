extends MarginContainer


@onready var tamers = $VBox/Tamers
@onready var libra = $VBox/Tamers/Libra
@onready var turn = $VBox/Counters/Turn
@onready var cycle = $VBox/Counters/Cycle
@onready var timer = $Timer

var battleground = null
var left = null
var right = null
var winner = null
var hunger = false


func set_attributes(input_: Dictionary) -> void:
	battleground  = input_.battleground
	
	var input = {}
	input.arena = self
	libra.set_attributes(input)
	
	for tamer in input_.tamers:
		add_tamer(tamer)
	
	init_counters()
	next_turn()


func add_tamer(tamer_: MarginContainer) -> void:
	tamer_.cradle.tamers.remove_child(tamer_)
	tamers.add_child(tamer_)
	tamer_.arena = self
	
	if tamers.get_child_count() == 2:
		left = tamer_
		tamer_.side = "left"
		tamers.move_child(tamer_, 0)
	else:
		right = tamer_
		tamer_.side = "right"


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
				libra.add_beast(side, beast)
		
		if libra.comparison.subtype != "equal" and libra.comparison.subtype != "similar":
			var tamers = {}
			
			match libra.comparison.subtype:
				"greater":
					tamers.winner = get("left")
					tamers.loser = get("right")
				"less":
					tamers.winner = get("right")
					tamers.loser = get("left")
			
			libra.give_beasts_to_tamer(tamers.winner)
			tamers.loser.health.get_damage(libra.get_damage())
		
		if hunger:
			for side in Global.arr.side:
				var tamer = get(side) 
				tamer.quench_hunger()
			
			next_cycle()
	else:
		timer.stop()


func next_cycle() -> void:
	turn.stack.set_number(0)
	cycle.stack.change_number(1)
	hunger = false


func _on_timer_timeout():
	next_turn()


func set_loser(tamer_: MarginContainer) -> void:
	for side in Global.arr.side:
		var tamer = get(side)
		
		if tamer != tamer_:
			winner = tamer
			break


