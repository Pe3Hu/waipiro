extends MarginContainer


@onready var leftSacrifices = $HBox/Sacrifices/Left
@onready var rightSacrifices = $HBox/Sacrifices/Right
@onready var leftAncestors = $HBox/Ancestors/Left
@onready var rightAncestors = $HBox/Ancestors/Right
@onready var leftDescendants = $HBox/Ancestors/Descendants/Left
@onready var middleDescendants = $HBox/Ancestors/Descendants/Middle
@onready var rightDescendants = $HBox/Ancestors/Descendants/Right

var arena = null


func set_attributes(input_: Dictionary) -> void:
	arena = input_.arena


func award() -> void:
	for side in Global.arr.side:
		var tamer = arena.get(side)
		tamer.domain.return_prey()
	
	fill_sacrifices()
	fill_ancestors()
	ascension_of_ancestors()
	spawn_descendants()
	spread_descendants()
	return_beasts()


func fill_sacrifices() -> void:
	for side in Global.arr.side:
		var tamer = arena.get(side)
		var worsts = tamer.domain.get_sorted_beasts("worst")
		var sacrifices = get(side+"Sacrifices")
		
		if tamer == arena.winner:
			worsts.pop_back()
			worsts.pop_back()
		
		for beast in worsts:
			tamer.domain.dormant.beasts.remove_child(beast)
			#sacrifices.add_child(beast)
			Global.arr.sacrifices.append(beast.index)


func fill_ancestors() -> void:
	for side in Global.arr.side:
		var tamer = arena.get(side)
		var bests = tamer.domain.get_sorted_beasts("best")
		var ancestors = get(side+"Ancestors")
		
		for beast in bests:
			tamer.domain.dormant.beasts.remove_child(beast)
			ancestors.add_child(beast)


func ascension_of_ancestors() -> void:
	var chances = {}
	chances.winner = [20, 15, 10, 5]
	chances.loser = [10, 5]
	
	for side in Global.arr.side:
		var tamer = arena.get(side)
		var ancestors = get(side+"Ancestors")
		
		for status in Global.arr.status:
			if arena.get(status) == tamer:
				for _i in chances[status].size():
					Global.rng.randomize()
					var luck = Global.rng.randi_range(0, 100)
					
					if true:#luck >= chances.winner[_i]:
						var beast = ancestors.get_child(_i)
						beast.ascension()


func spawn_descendants() -> void:
	var counts = [3, 2, 2, 1]
	
	for _i in leftAncestors.get_child_count():
		var input = {}
		input.rank = 0
		
		for _c in counts[_i]:
			var descendant = Global.scene.beast.instantiate()
			middleDescendants.add_child(descendant)
			descendant.set_attributes(input)
			descendant.visible = true
			
			var ancestors = []
			var pedigrees = []
			var elements = {}
			
			for element in Global.arr.element:
				elements[element] = 1
			
			for side in Global.arr.side:
				var _ancestors = get(side+"Ancestors")
				var ancestor = _ancestors.get_child(_i)
				ancestors.append(ancestor)
				
				pedigrees.append(ancestor.totem.couple.title.subtype)
				elements[ancestor.element] += 1
			
			input.pedigree = pedigrees.pick_random()
			
			if input.pedigree != null:
				for element in Global.arr.element:
					if !Global.dict.totem.element[element].has(input.pedigree):
						elements.erase(element)
					else:
						elements[element] += Global.dict.totem.element[element][input.pedigree]
			
			input.element = Global.get_random_key(elements)
			input.type = "legacy"
			input.rank = 0
			
			for _j in ancestors.front().chain.links.get_child_count():
				var links = []
				
				for ancestor in ancestors:
					var link = ancestor.chain.links.get_child(_j)
					links.append(link)
				
				var data = get_legacy_and_ascension_after_links_interbreed(links)
				var link = descendant.chain.links.get_child(_j)
				
				if _j < 2 and data.legacy < Global.num.link.inborn:
					data.legacy = Global.num.link.inborn
					descendant.chain.rank += data.legacy
				
				if data.legacy > 0:
					var essence = link.get("legacy")
					essence.couple.stack.set_number(data.legacy)
					essence.visible = true
				
				var essence = link.get("ascension")
				essence.couple.stack.set_number(data.ascension)
				
				if _j < 2:
					var aspect = Global.arr.aspect[_j]
					link.set_aspect(aspect)


func get_legacy_and_ascension_after_links_interbreed(links_: Array) -> Dictionary:
	var limits = {}
	limits.max = 0
	limits.min = 0
	var data = {}
	data.legacy = 0
	data.ascension = 0
	
	for link in links_:
		for _essence in Global.arr.essence:
			var essence = link.get(_essence)
			
			if _essence != "ascension":
				limits.max += essence.couple.stack.get_number()
			else:
				data.ascension += essence.couple.stack.get_number() / float(links_.size())
	
	if limits.max > 0:
		limits.max = floor(limits.max * 0.5)
		Global.rng.randomize()
		data.legacy = Global.rng.randi_range(limits.min, limits.max)
		
		#if Global.num.aspect.min > legacy:
		#	return 0
	
	return data


func spread_descendants() -> void:
	var datas = []
	var order = ["winner", "winner", "loser", "winner", "loser", "loser", "winner", "loser"]
	
	var sides = {}
	
	for status in Global.arr.status:
		for side in Global.arr.side:
			if arena.get(status) == arena.get(side):
				sides[status] = side 
	
	while middleDescendants.get_child_count() > 0:
		var data = {}
		data.descendant = middleDescendants.get_child(0)
		middleDescendants.remove_child(data.descendant)
		data.weight = data.descendant.chain.anchor.get_potential()
		datas.append(data)
	
	datas.sort_custom(func(a, b): return a.weight > b.weight)
	
	for _i in order.size():
		var status = order[_i]
		var side = sides[status]
		var descendant = datas[_i].descendant
		var descendants = get(side+"Descendants")
		descendants.add_child(descendant)
		var tamer = arena.get(status)
		descendant.set_domain(tamer.domain)


func return_beasts() -> void:
	for side in Global.arr.side:
		var tamer = arena.get(side)
		var ancestors = get(side+"Ancestors")
		var descendants = get(side+"Descendants")
		
		while descendants.get_child_count() > 0:
			var beast = descendants.get_child(0)
			descendants.remove_child(beast)
			tamer.domain.dormant.beasts.add_child(beast)
		
		while ancestors.get_child_count() > 0:
			var beast = ancestors.get_child(0)
			ancestors.remove_child(beast)
			tamer.domain.dormant.beasts.add_child(beast)
