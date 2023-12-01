extends MarginContainer


@onready var marker = $HBox/Marker
@onready var chain = $HBox/Chain

var domain = null
var index = 0


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


