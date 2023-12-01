extends MarginContainer


@onready var beasts = $VBox/Beasts
@onready var left = $VBox/HBox/Left
@onready var comparison = $VBox/HBox/Comparison
@onready var right = $VBox/HBox/Right

var arena = null
var capacity = null


func set_attributes(input_: Dictionary) -> void:
	arena = input_.arena
	capacity = 1
	
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
	var icon = get(side_)
	var value = 1#beast_.get_rank()
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
	while beasts.get_child_count() > 0:
		var beast = beasts.get_child(0)
		beasts.remove_child(beast)
		tamer_.domain.prey.beasts.add_child(beast)


func get_damage() -> int:
	return abs(left.get_number() - right.get_number())
