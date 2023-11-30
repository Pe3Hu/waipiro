extends MarginContainer


@onready var couple = $VBox/Couple
@onready var bg = $BG

var gameboard = null


func set_attributes(input_: Dictionary) -> void:
	gameboard = input_.gameboard
	
	set_icons(input_)


func set_icons(input_: Dictionary) -> void:
	var input = {}
	input.proprietor = self
	input.type = "suit"
	input.subtype = input_.suit
	input.value = input_.rank
	couple.set_attributes(input)
	
	var style = StyleBoxFlat.new()
	bg.set("theme_override_styles/panel", style)


func get_suit() -> String:
	return couple.title.subtype


func get_rank() -> int:
	return couple.stack.get_number()
