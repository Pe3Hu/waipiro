extends MarginContainer


@onready var marker = $HBox/Marker
@onready var chain = $HBox/Chain
@onready var chronicle = $HBox/Chronicle

var domain = null
var element = null
var index = 0
var lucky = [0, 1, 1, 1, 1, 2]
var deed = false
var blessing = false


func set_attributes(input_: Dictionary) -> void:
	domain = input_.domain
	element = input_.element
	index = Global.num.index.beast
	Global.num.index.beast += 1
	
	input_.beast = self
	chain.set_attributes(input_)
	chronicle.set_attributes(input_)
	set_icons()


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
	link.set_essence_value(input)
