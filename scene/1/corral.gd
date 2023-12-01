extends MarginContainer


@onready var beasts = $Beasts

var domain = null
var type = null


func set_attributes(input_: Dictionary) -> void:
	domain = input_.domain
	type = input_.type


func reshuffle() -> void:
	var _beasts = []
	
	while beasts.get_child_count() > 0:
		var beast = pull_beast()
		_beasts.append(beast)
	
	_beasts.shuffle()
	
	for beast in _beasts:
		beasts.add_child(beast)


func pull_beast() -> Variant:
	if beasts.get_child_count() > 0:
		var beast = beasts.get_child(0)
		beasts.remove_child(beast)
		
		if type == "dormant" and beasts.get_child_count() == 0 and !domain.tamer.arena.hunger:
			domain.tamer.arena.hunger = true
		
		return beast
	
	#domain.tamer.arena.set_loser(domain.tamer)
	return null
