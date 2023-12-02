extends MarginContainer


@onready var bg = $BG
@onready var innovation = $VBox/Innovation
@onready var legacy = $VBox/Legacy
@onready var ascension = $VBox/Ascension
@onready var destiny = $VBox/Destiny

var chain = null
var type = null
var aspect = null


func set_attributes(input_: Dictionary) -> void:
	chain = input_.chain
	type = input_.type
	aspect = input_.aspect
	
	set_essences(input_)


func set_essences(input_: Dictionary) -> void:
	for _essence in Global.arr.essence:
		var input = Dictionary(input_)
		input.type = _essence
		input.value = 0
	
		if input_.has(_essence):
			input.value = input_[_essence]
		
		set_essence(input)
		
		var essence = get(_essence)
		
		if custom_minimum_size.x == 0:
			custom_minimum_size.x = essence.size.x
		
		custom_minimum_size.y += essence.size.y
	
	var style = StyleBoxFlat.new()
	bg.set("theme_override_styles/panel", style)
	style.bg_color = Global.color.link[type]


func set_essence(input_: Dictionary) -> void:
	input_.link = self
	var essence = get(input_.type)
	essence.set_attributes(input_)


func get_multiplication_value() -> int:
	return round(innovation.get_value() + legacy.get_value()) * ascension.get_value()


func set_essence_value(input_: Dictionary) -> void:
	var essence = get(input_.type)
	essence.couple.stack.set_number(input_.value)
	set_aspect(input_.aspect)
	
	if input_.value > 0:
		essence.visible = true
	
	chain.anchor.recalc_aspect(input_.aspect)

func set_aspect(aspect_: String) -> void:
	aspect = aspect_
	
	for _essence in Global.arr.essence:
		var essence = get(_essence)
		essence.update_aspect(aspect)
