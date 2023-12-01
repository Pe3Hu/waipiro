extends MarginContainer


@onready var marker = $HBox/Marker
@onready var chain = $HBox/Chain

var domain = null
var index = 0
var lucky = [0, 1, 1, 1, 1, 2]
var deed = false


func set_attributes(input_: Dictionary) -> void:
	domain = input_.domain
	index = Global.num.index.beast
	Global.num.index.beast += 1
	
	input_.beast = self
	chain.set_attributes(input_)
	set_icons(input_)


func set_icons(input_: Dictionary) -> void:
	var input = {}
	input.proprietor = self
	input.type = "suit"
	input.subtype = input_.suit#sustenance
	input.value = index
	marker.set_attributes(input)


func get_suit() -> String:
	return marker.title.subtype


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
	var min = Global.num.aspect.min
	var max = victim_.chain.anchor.get(input.aspect).get_number()
	input.innovation = Global.rng.randi_range(min, max)
	chain.add_link(input)
