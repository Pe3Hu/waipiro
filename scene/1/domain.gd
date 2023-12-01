extends MarginContainer


@onready var dormant = $VBox/Corrals/Dormant
@onready var hunter = $VBox/Corrals/Hunter
@onready var prey = $VBox/Corrals/Prey

var tamer = null


func set_attributes(input_: Dictionary) -> void:
	tamer = input_.tamer
	input_.domain = self
	
	init_starter_kit_beasts()
	dormant.set_attributes(input_)
	hunter.set_attributes(input_)
	prey.set_attributes(input_)


func init_starter_kit_beasts() -> void:
	for suit in Global.arr.suit:
		for rank in Global.arr.rank:
			var input = {}
			input.domain = self
			input.rank = rank
			input.suit = suit
			
			for _i in Global.dict.beast.count[rank]:
				var beast = Global.scene.beast.instantiate()
				dormant.beasts.add_child(beast)
				beast.set_attributes(input)


func refill_hunters() -> void:
	if hunter.beasts.get_child_count() == 0:
		tamer.arena.set_loser(tamer)
	else:
		while hunter.beasts.get_child_count() > 0:
			var beast = hunter.beasts.get_child(0)
			hunter.beasts.remove_child(beast)
			dormant.beasts.add_child(beast)
	
	dormant.reshuffle()

