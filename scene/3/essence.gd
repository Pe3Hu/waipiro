extends MarginContainer


@onready var bg = $BG
@onready var couple = $Couple

var link = null
var type = null
var aspect = null


func set_attributes(input_: Dictionary) -> void:
	link = input_.link
	type = input_.type
	aspect = input_.aspect
	
	set_icons(input_)


func set_icons(input_: Dictionary) -> void:
	var input = {}
	input.proprietor = self
	input.type = "essence"
	input.subtype = type
	input.value = input_.value
	couple.set_attributes(input)
	
	if input_.value == 0:
		visible = false
	
	var style = StyleBoxFlat.new()
	bg.set("theme_override_styles/panel", style)
	style.bg_color = Global.color.aspect[aspect]
	couple.set_title_size(Global.vec.size.essence)


func get_value():
	return couple.stack.get_number()
