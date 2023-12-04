extends MarginContainer


@onready var beasts = $VBox/Beasts
@onready var left = $VBox/HBox/Left
@onready var comparison = $VBox/HBox/Comparison
@onready var right = $VBox/HBox/Right

var arena = null
var capacity = null
var previous = {}


func set_attributes(input_: Dictionary) -> void:
	arena = input_.arena
	capacity = 1
	previous.fight = {}
	previous.fight.left = null
	previous.fight.right = null
	previous.beast = {}
	previous.beast.left = null
	previous.beast.right = null
	
	init_icons()
	reset_icons()


func init_icons() -> void:
	var input = {}
	input.type = "number"
	input.subtype = 0
	left.set_attributes(input)
	right.set_attributes(input)
	
	left.number.set("theme_override_font_sizes/font_size", 32)
	right.number.set("theme_override_font_sizes/font_size", 32)


func reset_icons() -> void:
	var input = {}
	input.type = "comparison"
	input.subtype = "similar"
	comparison.set_attributes(input)
	
	left.set_number(0)
	right.set_number(0)
	comparison.custom_minimum_size = Vector2(Global.vec.size.sixteen*1.5)


func add_beast(side_: String, beast_: MarginContainer) -> void:
	beasts.add_child(beast_)
	roll_impulse_on_side(side_)


func roll_impulse_on_side(side_: String) -> void:
	for _i in Global.arr.side.size():
		if side_ == Global.arr.side[_i]:
			var icon = get(side_)
			var beast = beasts.get_child(_i)
			var value = beast.chain.anchor.cacl_impact()
			icon.change_number(value)
			update_comparison()


func update_comparison() -> void:
	var input = {}
	input.type = "comparison"
	input.subtype = "equal"
	
	if left.get_number() > right.get_number():
		input.subtype = "greater"
	
	if right.get_number() > left.get_number():
		input.subtype = "less"
	
	comparison.set_attributes(input)
	comparison.custom_minimum_size = Vector2(Global.vec.size.sixteen*1.5)


func give_beasts_to_tamer(tamer_: MarginContainer) -> void:
	previous.winner = tamer_
	
	while beasts.get_child_count() > 0:
		var beast = beasts.get_child(0)
		beasts.remove_child(beast)
		
		if beast.domain == tamer_.domain:
			tamer_.domain.hunter.beasts.add_child(beast)
		else:
			tamer_.domain.prey.beasts.add_child(beast)
	
	var winner = tamer_.domain.hunter.beasts.get_children().back()
	var loser = tamer_.domain.prey.beasts.get_children().back()
	
	if winner.chain.anchor.multiplication < loser.chain.anchor.multiplication:
		winner.deed = true


func get_damage() -> int:
	return abs(left.get_number() - right.get_number())


func set_previous() -> void:
	for _i in Global.arr.side.size():
		var side = Global.arr.side[_i]
		var beast = beasts.get_child(_i)
		#previous.fight[side] = "equilibrium"
		previous.beast[side] = beast.chain.anchor.multiplication


func set_achievements(phase_: String) -> void:
	for data in Global.dict.libra[phase_]:
		var func_name = "set_achievement_based_on_" +data.subtype+"_"+data.type
		call(func_name)


func set_achievement_based_on_previous_beast() -> void:
	for _i in Global.arr.side.size():
		var side = Global.arr.side[_i]
		var data = {}
		data.type = "beast"
		
		if previous[data.type][side] != null:
			var beast = beasts.get_child(_i)
			data.subtype = "previous"
			data.values = []
			data.values.append(beast.chain.anchor.multiplication)
			data.values.append(previous[data.type][side])
			data.condition = get_condition(data)
			beast.chronicle.update_achievement(data)


func set_achievement_based_on_previous_fight() -> void:
	for _i in Global.arr.side.size():
		var side = Global.arr.side[_i]
		var data = {}
		data.type = "fight"
		
		if previous[data.type][side] != null:
			var beast = beasts.get_child(_i)
			data.subtype = "previous"
			data.side = side
			data.condition = get_condition(data)
			beast.chronicle.update_achievement(data)


func set_achievement_based_on_current_beast() -> void:
	for _i in Global.arr.side.size():
		var _j = (_i + 1) % Global.arr.side.size()
		var beast = beasts.get_child(_i)
		var data = {}
		data.type = "beast"
		data.subtype = "current"
		data.values = []
		data.values.append(beast.chain.anchor.multiplication)
		beast = beasts.get_child(_j)
		
		data.values.append(beast.chain.anchor.multiplication)
		data.condition = get_condition(data)
		beast.chronicle.update_achievement(data)


func set_achievement_based_on_current_impulse() -> void:
	for _i in Global.arr.side.size():
		var side = Global.arr.side[_i]
		var beast = beasts.get_child(_i)
		var icon = get(side)
		var data = {}
		data.type = "impulse"
		data.subtype = "current"
		data.subcondition = "parity"
		data.impulse = icon.get_number()
		data.condition = get_condition(data)
		beast.chronicle.update_achievement(data)
		
		data.multiplication = beast.chain.anchor.multiplication
		data.subcondition = "lucky"
		data.condition = get_condition(data)
		beast.chronicle.update_achievement(data)


func set_achievement_based_on_current_fight() -> void:
	for _i in Global.arr.side.size():
		var side = Global.arr.side[_i]
		var beast = beasts.get_child(_i)
		var icon = get(side)
		var data = {}
		data.type = "fight"
		data.subtype = "current"
		data.side = side
		data.impulse = icon.get_number()
		data.condition = get_condition(data)
		beast.chronicle.update_achievement(data)
		previous.fight[side] = get_condition(data)


func get_condition(data_: Dictionary) -> Variant:
	match data_.type:
		"beast":
			if data_.values.front() > data_.values.back():
				return "stronger"
			if data_.values.front() < data_.values.back():
				return "weaker"
			
			return "equilibrium"
		"fight":
			match data_.subtype:
				"previous":
					return previous.fight[data_.side]
				"current":
					match comparison.subtype:
						"greater":
							if data_.side == "left":
								return "victory"
							else:
								return "defeat"
						"equal":
							return "equilibrium"
						"less":
							if data_.side == "right":
								return "victory"
							else:
								return "defeat"
		"impulse":
			match data_.subcondition:
				"parity":
					match data_.impulse % 2:
						0:
							return "even"
						1:
							return "odd"
				"lucky":
					if data_.multiplication * 0.5 <= data_.impulse:
							return "stronger"
					else:
							return "weaker"
	
	return null
