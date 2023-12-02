extends MarginContainer


@onready var aqua = $Elements/Aqua
@onready var wind = $Elements/Wind
@onready var fire = $Elements/Fire
@onready var earth = $Elements/Earth

var tamer = null


func set_attributes(input_: Dictionary) -> void:
	tamer = input_.tamer
	
	set_couples()


func set_couples() -> void:
	for element in Global.arr.element:
		var couple = get(element)
		
		var input = {}
		input.proprietor = self
		input.type = "element"
		input.subtype = element
		input.value = 0
		couple.set_attributes(input)


func update_couple_based_on_beast(beast_: MarginContainer) -> void:
	var couple = get(beast_.element)
	couple.stack.change_number(1)
	
	if couple.stack.get_number() >= Global.num.source.limit:
		couple.stack.change_number(-Global.num.source.limit)
		beast_.blessing = true
