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
		input.aspect = aspect
		input.legacy = Global.num.link.inborn
		add_link(input)
		free -= input.legacy
		
	
	for _i in free:
		var input = {}
		input.aspect = Global.arr.aspect.pick_random()
		input.innovation = 1
		add_link(input)


func add_link(input_: Dictionary) -> void:
	input_.chain = self
	input_.type = get_next_link_type()
	
	if !input_.has("ascension"):
		input_.ascension = Global.num.essence.ascension
	
	var link = Global.scene.link.instantiate()
	links.add_child(link)
	link.set_attributes(input_)


func get_next_link_type() -> Variant:
	for type in limits:
		if limits[type].has(links.get_child_count()):
			return type
	
	return null
