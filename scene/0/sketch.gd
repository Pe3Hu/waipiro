extends MarginContainer


@onready var cradle = $HBox/Cradle
@onready var colosseum = $HBox/Сolosseum


func _ready() -> void:
	var input = {}
	input.sketch = self
	cradle.set_attributes(input)
	colosseum.set_attributes(input)
