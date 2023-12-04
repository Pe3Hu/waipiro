extends MarginContainer


@onready var vigor = $HBox/Indicators/Vigor
@onready var standard = $HBox/Indicators/Standard
@onready var fatigue = $HBox/Indicators/Fatigue
@onready var marker = $HBox/Marker

var tamer = null
var value = {}
var limits = {}
var state = null


func set_attributes(input_: Dictionary) -> void:
	tamer = input_.tamer
	limits = input_.limits
	
	value.total = int(input_.total)
	value.current = int(input_.total)
	init_states()
	
	var input = {}
	input.proprietor = self
	input.type = "tribe"
	input.subtype = str(tamer.index)
	input.value = tamer.index
	marker.set_attributes(input)


func init_states() -> void:
	for type in Global.arr.state:
		var indicator = get(type)
		
		var input = {}
		input.health = self
		input.type = type
		input.max = limits[type] * value.total
		indicator.set_attributes(input)
	
	update_state()
	get_damage(0)


func update_state() -> void:
	for _state in Global.arr.state:
		var indicator = get(_state)
		
		if indicator.bar.value > 0:
			state = _state
			break


func get_damage(damage_: int) -> void:
	var indicator = get(state) 
	indicator.update_value("current", -damage_)
	update_state()
	
	if !tamer.bloods.first:
		if damage_ > 0:
			tamer.bloods.first = true


