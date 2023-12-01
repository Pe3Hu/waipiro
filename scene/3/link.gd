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
		var input = {}
		input.link = self
		input.type = _essence
		input.aspect = input_.aspect
		input.value = 0
		
		if input_.has(_essence):
			input.value = input_[_essence]
		
		var essence = get(_essence)
		essence.set_attributes(input)
		
		if custom_minimum_size.x == 0:
			custom_minimum_size.x = essence.size.x
		
		custom_minimum_size.y += essence.size.y
	
	var style = StyleBoxFlat.new()
	bg.set("theme_override_styles/panel", style)
	style.bg_color = Global.color.link[type]


func get_multiplication_value() -> int:
	return round(innovation.get_value() + legacy.get_value()) * ascension.get_value()
	
	
