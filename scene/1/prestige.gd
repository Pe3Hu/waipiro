extends MarginContainer


@onready var couple = $Couple

var gameboard = null


func set_attributes(input_: Dictionary) -> void:
	gameboard = input_.gameboard
	
	input_.proprietor = self
	couple.set_attributes(input_)
	couple.set_title_size(Vector2(Global.vec.size.prestige))

