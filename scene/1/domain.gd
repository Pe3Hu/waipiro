extends MarginContainer


@onready var dormant = $VBox/Corrals/Dormant
@onready var hunter = $VBox/Corrals/Hunter
@onready var prey = $VBox/Corrals/Prey

var tamer = null


func set_attributes(input_: Dictionary) -> void:
	tamer = input_.tamer
	input_.domain = self
	
	init_starter_kit_beasts()
	
	for type in Global.arr.corral:
		var corral = get(type)
		input_.type = type
		corral.set_attributes(input_)


func init_starter_kit_beasts() -> void:
	#for suit in Global.arr.suit:
	for rank in Global.arr.rank:
		var input = {}
		input.domain = self
		input.rank = rank
		input.suit = Global.arr.suit[tamer.index]
		
		for _i in Global.dict.beast.count[rank]:
			var beast = Global.scene.beast.instantiate()
			dormant.beasts.add_child(beast)
			beast.set_attributes(input)


func refill_hunters() -> void:
	if hunter.beasts.get_child_count() == 0:
		tamer.arena.set_loser(tamer)
	else:
		while hunter.beasts.get_child_count() > 0:
			var beast = hunter.beasts.get_child(0)
			hunter.beasts.remove_child(beast)
			dormant.beasts.add_child(beast)
	
	dormant.reshuffle()


func quench_hunger() -> void:
	var beasts = {}
	beasts.hunter = []
	beasts.prey = []
	
	for type in beasts:
		var corral = get(type)
		
		while corral.beasts.get_child_count() > 0:
			var beast = corral.pull_beast()
			beasts[type].append(beast)
	
		beasts[type].sort_custom(func(a, b): return a.chain.anchor.multiplication < a.chain.anchor.multiplication)
	
	for beast in beasts.hunter:
		var contribution = beast.roll_contribution()
		var victim = null
		
		match contribution:
			"offal":
				victim = beasts.prey.front()
			"fillet":
				victim = beasts.prey.pick_random()
			"loin":
				victim = beasts.prey.back()
		
		beast.assimilation(victim)
		beasts.prey.erase(victim)
		dormant.beasts.add_child(beast)
		tamer.opponent.domain.dormant.beasts.add_child(victim)
