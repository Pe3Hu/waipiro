extends MarginContainer


@onready var achievements = $Achievements

var beast = null


func set_attributes(input_: Dictionary) -> void:
	beast = input_.beast
	
	var data = {}
	data.type = "beast"
	data.subtype = "previous"
	data.condition = "element"
	add_achievement(data)


func update_achievement(input_: Dictionary) -> void:
	var achievement = get_achievement(input_)
	
	if achievement == null:
		add_achievement(input_)
		achievement = achievements.get_children().back()
	
	achievement.update_counter(1)


func get_achievement(input_: Dictionary) -> Variant:
	for achievement in achievements.get_children():
		var flag = true
		
		for key in Global.arr.achievement:
			var icon = achievement.get(key)
			
			if icon.subtype != input_[key]:
				flag = false
				break
		
		if flag:
			return achievement
	
	return null


func add_achievement(input_: Dictionary) -> void:
	input_.chronicle = self
	
	for title in Global.dict.achievement.title:
		var description = Global.dict.achievement.title[title]
		var flag = true
	
		for key in Global.arr.achievement:
			if description[key] != input_[key]:
				flag = false
				break
		
		if flag:
			input_.title = title
			break
	
	var achievement = Global.scene.achievement.instantiate()
	achievements.add_child(achievement)
	achievement.set_attributes(input_)
