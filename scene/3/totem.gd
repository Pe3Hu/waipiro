extends MarginContainer


@onready var bg = $BG
@onready var couple = $Couple

var beast = null


func set_attributes(input_: Dictionary) -> void:
	beast = input_.beast
	
	var style = StyleBoxFlat.new()
	bg.set("theme_override_styles/panel", style)


func set_pedigree(pedigree_: String) -> void:
	var input = {}
	input.proprietor = self
	input.type = "pedigree"
	input.subtype = pedigree_
	input.value = 1
	couple.set_attributes(input)
	
	#var style = bg.get("theme_override_styles/panel")
	#style.bg_color = Global.color.aspect[pedigree_]
	couple.set_title_size(Global.vec.size.essence)
	visible = true


func rise_evolution() -> void:
	couple.stack.change_value(1)
