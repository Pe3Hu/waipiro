extends MarginContainer


@onready var dexterity = $Aspects/Dexterity
@onready var strength = $Aspects/Strength

var chain = null


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
	#print(aspect_)
	for link in chain.links.get_children():
		if link.aspect == aspect_:
			value += link.get_multiplication_value()
		#print([value, link.get_multiplication_value()])
	
	var icon = get(aspect_)
	icon.set_number(value)
