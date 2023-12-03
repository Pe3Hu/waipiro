extends MarginContainer


@onready var bg = $BG
@onready var type = $HBox/Type
@onready var subtype = $HBox/Subtype
@onready var condition = $HBox/Condition
@onready var counter = $HBox/Counter
@onready var degree = $HBox/Degree
@onready var rank = $HBox/Rank

var chronicle = null
var title = null


func set_attributes(input_: Dictionary) -> void:
	chronicle = input_.chronicle
	title = input_.title
	
	set_icons()


func set_icons() -> void:
	var description = Global.dict.achievement.title[title]
	var keys = ["type", "subtype", "condition"]
	
	for key in keys:
		var icon = get(key)
		var input = {}
		input.proprietor = self
		input.type = "achievement"
		input.subtype = description[key]
		icon.set_attributes(input)
	
	keys = ["counter", "degree", "rank"]
	
	for key in keys:
		var icon = get(key)
		var input = {}
		input.proprietor = self
		input.type = "number"
		input.subtype = 0
		
		if key == "degree":
			input.subtype = description[key]
		
		icon.set_attributes(input)


func update_counter(value_: int) -> void:
	counter.change_number(value_)
