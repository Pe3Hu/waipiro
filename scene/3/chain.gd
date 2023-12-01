extends MarginContainer


@onready var bg = $BG
@onready var links = $HBox/Links
@onready var anchor = $HBox/Anchor

var beast = null
var rank = null
var limits = {}


func set_attributes(input_: Dictionary) -> void:
	beast = input_.beast
	rank = input_.rank
	
	limits.inborn = [0, 1]
	limits.young = [2]
	limits.mature = [3, 4]
	limits.old = [5, 6, 7]
	
	var input = {}
	input.chain = self
	anchor.set_attributes(input)
	spread_aspects()
	
	for aspect in Global.arr.aspect:
		anchor.recalc_aspect(aspect)


func spread_aspects() -> void:
	var free = int(rank)
	
	for aspect in Global.arr.aspect:
		var input = {}
		input.chain = self
		input.aspect = aspect
		input.type = get_next_link_type()
		input.legacy = Global.num.link.inborn
		input.ascension = Global.num.essence.ascension
		free -= input.legacy
		
		var link = Global.scene.link.instantiate()
		links.add_child(link)
		link.set_attributes(input)
	
	for _i in free:
		var input = {}
		input.chain = self
		input.aspect = Global.arr.aspect.pick_random()
		input.type = get_next_link_type()
		input.innovation = 1
		input.ascension = Global.num.essence.ascension
		
		var link = Global.scene.link.instantiate()
		links.add_child(link)
		link.set_attributes(input)


func get_next_link_type() -> Variant:
	for type in limits:
		if limits[type].has(links.get_child_count()):
			return type
	
	return null
