extends MarginContainer


@onready var beasts = $Beasts

var domain = null


func set_attributes(input_: Dictionary) -> void:
	domain = input_.domain


func reshuffle() -> void:
	var _beasts = []
	
	while beasts.get_child_count() > 0:
		var beast = get_child_count()
		_beasts.append(beast)
	
	_beasts.shuffle()
	
	for beast in _beasts:
		_beasts.add_child(beast)


func pull_beast() -> Variant:
	if beasts.get_child_count() > 0:
		var beast = beasts.get_child(0)
		beasts.remove_child(beast)
		return beast
	
	#domain.tamer.arena.set_loser(domain.tamer)
	return null
