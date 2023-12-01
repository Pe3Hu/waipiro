extends MarginContainer


@onready var dexterity = $Aspects/Dexterity
@onready var strength = $Aspects/Strength

var chain = null
var multiplication = null


func set_attributes(input_: Dictionary) -> void:
	chain = input_.chain
	
	for aspect in Global.arr.aspect:
		var input = {}
		input.type = "number"
		input.subtype = 0
		var icon = get(aspect)
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
	
	var icon = get(aspect_)
	icon.set_number(value)
	multiplication = 1
	
	for aspect in Global.arr.aspect:
		icon = get(aspect)
		multiplication *= icon.get_number()


func cacl_impact() -> int:
	Global.rng.randomize()
	var impact = Global.rng.randi_range(0, multiplication)
	return impact


func get_aspect_based_on(thirst_: String) -> String:
	var aspects = []
	
	for aspect in Global.arr.aspect:
		aspects.append(aspect)
	
	aspects.sort_custom(func(a, b): return get(a).get_number() < get(b).get_number())
	var aspect = null
	
	match thirst_:
		"large":
			aspect = aspects.front()
		"medium":
			aspect = aspects.pick_random()
		"small":
			aspect = aspects.back()
	
	return aspect
