extends MarginContainer


@onready var cards = $Cards

var gameboard = null
var capacity = null


func set_attributes(input_: Dictionary) -> void:
	gameboard = input_.gameboard
	
	update_capacity()


func update_capacity() -> void:
	capacity = 0
	
	for subtype in Global.arr.prestige:
		var prestige = gameboard.get(subtype)
		capacity += prestige.couple.stack.get_number()
	 

func refill() -> void:
	gameboard.reshuffle_available()
	
	while cards.get_child_count() < capacity and gameboard.tamer.arena.winner == null:# and gameboard.discard.cards.get_child_count() > 0:
		var card = gameboard.pull_random_card()
		
		if card != null:
			add_card(card)


func add_card(card_: MarginContainer) -> void:
	cards.add_child(card_)


func refill_based_on_card_indexs(indexs_: Array) -> void:
	for index in indexs_:
		draw_indexed_card(index)


func draw_indexed_card(index_: int) -> void:
	var card = gameboard.pull_indexed_card(index_)
	add_card(card)
