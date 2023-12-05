extends MarginContainer


@onready var domain = $HBox/Domain
@onready var health = $HBox/VBox/Health
@onready var source = $HBox/VBox/Source

var cradle = null
var arena = null
var side = null
var index = null
var opponent = null
var bloods = {}


func set_attributes(input_: Dictionary) -> void:
	cradle = input_.cradle
	index = Global.num.index.tamer
	Global.num.index.tamer += 1
	
	for blood in Global.arr.blood:
		bloods[blood] = false
	
	init_nodes()


func init_nodes() -> void:
	var input = {}
	input.tamer = self
	domain.set_attributes(input)
	source.set_attributes(input)
	input.limits = {}
	input.limits.vigor = 0.25
	input.limits.standard = 0.5
	input.limits.fatigue = 0.25
	input.total = 100
	health.set_attributes(input)

