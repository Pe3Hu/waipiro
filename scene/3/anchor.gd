extends MarginContainer


@onready var dexterityMax = $Aspects/Max/Dexterity
@onready var strengthMax = $Aspects/Max/Strength
@onready var dexterityRoll = $Aspects/Roll/Dexterity
@onready var strengthRoll = $Aspects/Roll/Strength

var chain = null
var multiplication = null
var amount = null


func set_attributes(input_: Dictionary) -> void:
	chain = input_.chain
	
	for aspect in Global.arr.aspect:
		var input = {}
		input.type = "number"
		input.subtype = 0
		var icon = get(aspect+"Roll")
		icon.set_attributes(input)
		#icon.visible = false
		icon = get(aspect+"Max")
		icon.set_attributes(input)
		icon.bg.visible = true
		
		var style = StyleBoxFlat.new()
		icon.bg.set("theme_override_styles/panel", style)
		style.bg_color = Global.color.aspect[aspect]
		
		custom_minimum_size = Vector2(Global.vec.size.letter)


func recalc_aspect(aspect_: String) -> void:
	var value = 0
	
	for link in chain.links.get_children():
		if link.aspect == aspect_:
			value += link.get_multiplication_value()
	
	value = round(value)
	var icon = get(aspect_+"Max")
	icon.set_number(value)
	multiplication = 1
	amount = 0
	
	for aspect in Global.arr.aspect:
		icon = get(aspect+"Max")
		multiplication *= icon.get_number()
		amount += icon.get_number()


func cacl_impact() -> int:
	if chain.beast.blessing:
		for aspect in Global.arr.aspect:
			var icon = get(aspect+"Max")
			var blessing = Global.dict.element.blessing[chain.beast.element][aspect]
			icon.change_number(blessing)
	
	var impact = 1
	
	for aspect in Global.arr.aspect:
		var icon = get(aspect+"Max")
		Global.rng.randomize()
		var value = Global.rng.randi_range(0, icon.get_number())
		icon = get(aspect+"Roll")
		icon.set_number(value)
		impact *= value
	
	if chain.beast.blessing:
		for aspect in Global.arr.aspect:
			var icon = get(aspect+"Max")
			var blessing = Global.dict.element.blessing[chain.beast.element][aspect]
			icon.change_number(-blessing)
		
		chain.beast.blessing = false
		var data = {}
		data.type = "beast"
		data.subtype = "current"
		data.condition = "element"
		chain.beast.chronicle.update_achievement(data)
	
	return impact


func get_aspect_based_on(thirst_: String) -> String:
	var aspects = []
	
	for aspect in Global.arr.aspect:
		aspects.append(aspect)
	
	aspects.sort_custom(func(a, b): return get(a+"Max").get_number() < get(b+"Max").get_number())
	var aspect = null
	
	match thirst_:
		"large":
			aspect = aspects.front()
		"medium":
			aspect = aspects.pick_random()
		"small":
			aspect = aspects.back()
	
	return aspect


func get_potential() -> float:
	var legacy = 0
	var ascension = 0
	
	for link in chain.links.get_children():
		legacy += link.get("legacy").get_value()
		ascension += link.get("ascension").get_value()
	
	var potential = legacy * ascension
	return potential
