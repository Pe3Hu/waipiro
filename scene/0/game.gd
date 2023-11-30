extends Node


@onready var sketch = $Sketch


func _ready() -> void:
	#datas.sort_custom(func(a, b): return a.value < b.value)
	#012 description
	pass


func _input(event) -> void:
	if event is InputEventKey:
		match event.keycode:
			KEY_SPACE:
				if event.is_pressed() && !event.is_echo():
					sketch.colosseum.arenas.get_child(0).next_turn()


func _process(delta_) -> void:
	$FPS.text = str(Engine.get_frames_per_second())
