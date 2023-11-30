extends MarginContainer


@onready var couple = $VBox/Couple
@onready var bg = $BG

var gameboard = null
var sustenance = null
var victims = 0


func set_attributes(input_: Dictionary) -> void:
	gameboard = input_.gameboard
	sustenance = input_.sustenance
	
	set_icons(input_)


func set_icons(input_: Dictionary) -> void:
	var input = {}
	input.proprietor = self
	input.type = "suit"
	input.subtype = input_.suit#sustenance
	input.value = input_.rank
	couple.set_attributes(input)
	
	var style = StyleBoxFlat.new()
	bg.set("theme_override_styles/panel", style)


func get_suit() -> String:
	return couple.title.subtype


func get_rank() -> int:
	return couple.stack.get_number()


func add_victim(victim_: MarginContainer) -> void:
	var value = null
	victims += 1
	#victims.append(victim_)
	
	match sustenance:
		"scavenger":
			value = victim_.get_rank()
		"herbivore":
			value = 1
		"predator":
			value = round(victim_.get_rank() * 0.5)
	
	couple.stack.change_number(value)
