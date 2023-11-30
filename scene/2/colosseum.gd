extends MarginContainer


@onready var arenas = $Arenas

var sketch = null


func set_attributes(input_: Dictionary) -> void:
	sketch  = input_.sketch
	
	init_arenas()


func init_arenas() -> void:
	for _i in 1:
		var input = {}
		input.battleground = self
		input.tamers = []
		
		for _j in 2:
			var tamer = sketch.cradle.tamers.get_child(_j)
			input.tamers.append(tamer)
		
		var arena = Global.scene.arena.instantiate()
		arenas.add_child(arena)
		arena.set_attributes(input)
