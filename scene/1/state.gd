extends MarginContainer


@onready var bar = $ProgressBar
@onready var value = $Value

var health = null
var type = null


func set_attributes(input_: Dictionary) -> void:
	health = input_.health
	type = input_.type
	bar.max_value = input_.max
	custom_minimum_size = Vector2(Global.vec.size.state)
	custom_minimum_size.x *= bar.max_value / health.value.total
	set_colors()


func set_colors() -> void:
	var keys = ["fill", "background"]
	bar.value = bar.max_value
	update_value("current", 0)
	
	for key in keys:
		var style_box = StyleBoxFlat.new()
		style_box.bg_color = Global.color.state[type][key]
		var path = "theme_override_styles/" + key
		bar.set(path, style_box)


func update_value(value_: String, shift_: int) -> void:
	match value_:
		"current":
			bar.value += shift_
			
			if bar.value < 0:
				health.update_type()
				visible = false
				health.get_damage(-bar.value)
				bar.value = 0
				
				if type == "fatigue":
					health.tamer.arena.set_loser(health.tamer)
			
			value.text = str(bar.value)
		"maximum":
			bar.max_value += shift_


func get_percentage() -> int:
	return floor(bar.value * 100 / bar.max_value)


func reset() -> void:
	bar.value = bar.max_value


func _on_progress_bar_changed():
	pass # Replace with function body.