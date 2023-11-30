extends MarginContainer


@onready var tamers = $VBox/Tamers
@onready var libra = $VBox/Tamers/Libra

var battleground = null
var left = null
var right = null


func set_attributes(input_: Dictionary) -> void:
	battleground  = input_.battleground
	
	var input = {}
	input.arena = self
	libra.set_attributes(input)
	
	for tamer in input_.tamers:
		add_tamer(tamer)
	
	next_turn()


func add_tamer(tamer_: MarginContainer) -> void:
	tamer_.cradle.tamers.remove_child(tamer_)
	tamers.add_child(tamer_)
	tamer_.arena = self
	
	
	if tamers.get_child_count() == 2:
		left = tamer_
		tamer_.side = "left"
		tamers.move_child(tamer_, 0)
	else:
		right = tamer_
		tamer_.side = "right"


func next_turn() -> void:
	libra.reset_icons()
	
	for side in Global.arr.side:
		var tamer = get(side)
		tamer.gameboard.hand.refill()
		
		while tamer.gameboard.hand.cards.get_child_count() > 0:
			var card = tamer.gameboard.hand.cards.get_child(0)
			tamer.gameboard.hand.cards.remove_child(card)
			libra.add_card(side, card)
	
	
	if libra.comparison.subtype != "equal":
		var tamer = null
		
		match libra.comparison.subtype:
			"greater":
				tamer = get("left")
			"less":
				tamer = get("right")
		
		libra.give_cards_to_tamer(tamer)
