extends MarginContainer


@onready var bg = $BG

var card = null


func set_attributes(input_: Dictionary) -> void:
	card = input_.card
