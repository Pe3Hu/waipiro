extends MarginContainer


@onready var marker = $HBox/Marker
@onready var totem = $HBox/Totem
@onready var chain = $HBox/Chain
@onready var chronicle = $HBox/Chronicle

var domain = null
var element = null
var index = 0
var lucky = [0, 1, 1, 1, 1, 2]
var deed = false
var blessing = false
var ratings = {}


func set_attributes(input_: Dictionary) -> void:
	if Global.arr.sacrifices.is_empty():
		index = Global.num.index.beast
		Global.num.index.beast += 1
	else:
		index = Global.arr.sacrifices.pop_front()
	
	if input_.has("domain"):
		element = input_.element
		set_domain(input_.domain)
	
	input_.beast = self
	totem.set_attributes(input_)
	chain.set_attributes(input_)
	chronicle.set_attributes(input_)


func set_icons() -> void:
	var input = {}
	input.proprietor = self
	input.type = "tribe"
	input.subtype = str(domain.tamer.index)
	input.value = index
	marker.set_attributes(input)


func roll_thirst() -> String:
	var thirst = "medium"
	var roll = lucky.pick_random()
	
	if roll == lucky.front():
		thirst = "small"
		
	if roll == lucky.back():
		thirst = "large"
	
	return thirst


func roll_contribution() -> String:
	var contribution = "fillet"
	var roll = lucky.pick_random()
	
	if roll == lucky.front():
		contribution = "offal"
		
	if roll == lucky.back():
		contribution = "loin"
		
	return contribution


func assimilation(victim_: MarginContainer) -> void:
	var input = {}
	var thirst = roll_thirst()
	input.aspect = victim_.chain.anchor.get_aspect_based_on(thirst)
	Global.rng.randomize()
	var _min = Global.num.aspect.min
	var _max = victim_.chain.anchor.get(input.aspect+"Max").get_number()
	input.type = "innovation"
	input.value = Global.rng.randi_range(_min, _max)
	var link = chain.get_next_free_link()
	
	if link != null:
		link.set_essence_value(input)
	else:
		for _i in 2:
			link = chain.links.get_child(_i)
			
			if link.aspect == input.aspect:
				input.type = "legacy"
				input.value = 1
				link.change_essence_value(input)


func ascension() -> void:
	if totem.couple.title.subtype != null:
		totem.rise_evolution()
	else:
		var input = {}
		input.pedigree = null
		input.evolution = 1
		
		#var correlation = {}
		#
		#for aspect in Global.arr.aspect:
			#var icon = chain.anchor.get(aspect+"Max")
			#correlation[aspect] = float(icon.get_number()) / chain.anchor.amount
		
		var correlation = float(chain.anchor.get("dexterityMax").get_number()) / chain.anchor.get("strengthMax").get_number()
		var datas = []
		
		for pedigree in Global.dict.totem.element[element]:
			var data = {}
			data.pedigree = pedigree
			data.title = Global.dict.totem.pedigree[pedigree][1]
			data.ascensions = Global.dict.totem.title[data.title].ascensions
			data.correlation = data.ascensions.dexterity / data.ascensions.strength
			data.affinity = abs(correlation - data.correlation)
			data.weight = 1 + (3 - Global.dict.totem.element[element][pedigree]) * 0.5
			data.value = data.affinity * data.weight
			datas.append(data)
		
		datas.sort_custom(func(a, b): return a.value < b.value)
		totem.set_pedigree(datas.front().pedigree)


func rise_rating(wound_: int) -> void:
	ratings.victory += 1
	ratings.wound += wound_


func reset() -> void:
	for rating in Global.arr.rating:
		ratings[rating] = 0


func set_domain(domain_: MarginContainer) -> void:
	domain = domain_
	
	set_icons()
	reset()
