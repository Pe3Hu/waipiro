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
	for rank in Global.arr.rank:
		var input = {}
		input.domain = self
		input.rank = rank
		input.element = Global.arr.element[tamer.index]#Global.arr.element.pick_random()
		
		for _i in Global.dict.beast.count[rank]:
			var beast = Global.scene.beast.instantiate()
			dormant.beasts.add_child(beast)
			beast.set_attributes(input)


func refill_dormants() -> void:
	#if hunter.beasts.get_child_count() == 0:
		#tamer.arena.set_loser(tamer)
	#else:
	while hunter.beasts.get_child_count() > 0:
		var beast = hunter.beasts.get_child(0)
		hunter.beasts.remove_child(beast)
		dormant.beasts.add_child(beast)
	
	#dormant.reshuffle()


func return_prey() -> void:
	while prey.beasts.get_child_count() > 0:
		var beast = prey.beasts.get_child(0)
		prey.beasts.remove_child(beast)
		tamer.opponent.domain.dormant.beasts.add_child(beast)


func quench_hunger() -> void:
	var beasts = {}
	beasts.hunter = []
	beasts.prey = []
	
	for type in beasts:
		var corral = get(type)
		
		while corral.beasts.get_child_count() > 0:
			var beast = corral.pull_beast()
			beasts[type].append(beast)
	
		beasts[type].sort_custom(func(a, b): return a.chain.anchor.multiplication < b.chain.anchor.multiplication)
		
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


func get_beasts_based_on_rating() -> Array:
	var beasts = []
	refill_dormants()
	
	beasts.append_array(dormant.beasts.get_children()) 
	beasts.sort_custom(func(a, b): return a.ratings.victory > b.ratings.victory)
	return beasts


func get_bests_beasts() -> Array:
	var beasts = get_beasts_based_on_rating()
	var bests = []
	var result = []
	var n = 4
	
	for _i in n:
		if bests.is_empty():
			for _j in beasts.size():
				if beasts[_j].ratings.victory == beasts.front().ratings.victory:
					bests.append(beasts[_j])
				else:
					break
			
			bests.sort_custom(func(a, b): return a.ratings.wound > b.ratings.wound)
		
		var beast = bests.pop_front()
		result.append(beast)
		beasts.erase(beast)
		var link = beast.chain.get_next_free_link()
		var index = beast.chain.links.get_children().find(link)
		if index == -1:
			index = beast.chain.links.get_child_count()
		
		var links = beast.chain.rank - 2
		print([beast.index, beast.ratings, links, index - links, index - links ==  beast.ratings.victory])
	
	return result
