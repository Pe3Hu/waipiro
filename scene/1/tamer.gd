extends MarginContainer


@onready var domain = $VBox/Domain
@onready var health = $VBox/Health

var cradle = null
var arena = null
var side = null
var index = null
var opponent = null


func set_attributes(input_: Dictionary) -> void:
	cradle = input_.cradle
	index = Global.num.index.tamer
	Global.num.index.tamer += 1
	
	var input = {}
	input.tamer = self
	domain.set_attributes(input)
	input.limits = {}
	input.limits.vigor = 0.25
	input.limits.standard = 0.5
	input.limits.fatigue = 0.25
	input.total = 100
	health.set_attributes(input)

