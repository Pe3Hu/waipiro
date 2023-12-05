extends MarginContainer


@onready var bg = $BG
@onready var couple = $Couple

var beast = null
var title = null


func set_attributes(input_: Dictionary) -> void:
	beast = input_.beast
	
	var style = StyleBoxFlat.new()
	bg.set("theme_override_styles/panel", style)


func set_pedigree(pedigree_: String) -> void:
	var input = {}
	input.proprietor = self
	input.type = "pedigree"
	input.subtype = pedigree_
	input.value = 0
	couple.set_attributes(input)
	rise_evolution()

	#var style = bg.get("theme_override_styles/panel")
	#style.bg_color = Global.color.aspect[pedigree_]
	couple.set_title_size(Global.vec.size.essence)
	visible = true


func rise_evolution() -> void:
	couple.stack.change_number(1)
	title = Global.dict.totem.pedigree[couple.title.subtype][couple.stack.get_number()]
	
	for link in beast.chain.links.get_children():
		update_link_ascensions(link)


func update_link_ascensions(link_: MarginContainer) -> void:
	if link_.aspect != null:
		var ascensions = {}
		var essence = link_.get("ascension")
		ascensions.old = essence.couple.stack.get_number()
		ascensions.new = Global.dict.totem.title[title].ascensions[link_.aspect]
		ascensions.best = max(ascensions.new, ascensions.old)
		
		var weights = {}
		
		for key in ascensions:
			if !weights.has(ascensions[key]):
				weights[ascensions[key]] = 0
			
			weights[ascensions[key]] += 1
		
		ascensions.result = Global.get_random_key(weights)
		#if couple.stack.get_number() > 1:
			#var previous = Global.dict.totem.pedigree[couple.title.subptype][couple.stack.get_number()-1]
			#input.value -= Global.dict.totem.title[previous].ascensions[link.aspect]
		
		essence.couple.stack.set_number(ascensions.result)
