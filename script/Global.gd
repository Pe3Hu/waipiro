extends Node


var rng = RandomNumberGenerator.new()
var arr = {}
var num = {}
var vec = {}
var color = {}
var dict = {}
var flag = {}
var node = {}
var scene = {}


func _ready() -> void:
	init_arr()
	init_num()
	init_vec()
	init_color()
	init_dict()
	init_node()
	init_scene()


func init_arr() -> void:
	arr.element = ["aqua", "wind", "fire", "earth"]
	arr.rank = [1, 2, 3, 4, 5]#, 6]
	arr.suit = ["aqua", "wind", "fire", "earth"]
	arr.side = ["left", "right"]
	arr.prestige = ["senior", "junior"]
	arr.counter = ["cycle", "turn"]
	arr.sustenance = ["scavenger", "herbivore", "predator"]
	arr.state = ["vigor", "standard", "fatigue"]


func init_num() -> void:
	num.index = {}
	num.index.tamer = 0


func init_dict() -> void:
	init_neighbor()
	init_beast()
	
	dict.thousand = {}
	dict.thousand[""] = "K"


func init_neighbor() -> void:
	dict.neighbor = {}
	dict.neighbor.linear3 = [
		Vector3( 0, 0, -1),
		Vector3( 1, 0,  0),
		Vector3( 0, 0,  1),
		Vector3(-1, 0,  0)
	]
	dict.neighbor.linear2 = [
		Vector2( 0,-1),
		Vector2( 1, 0),
		Vector2( 0, 1),
		Vector2(-1, 0)
	]
	dict.neighbor.diagonal = [
		Vector2( 1,-1),
		Vector2( 1, 1),
		Vector2(-1, 1),
		Vector2(-1,-1)
	]
	dict.neighbor.zero = [
		Vector2( 0, 0),
		Vector2( 1, 0),
		Vector2( 1, 1),
		Vector2( 0, 1)
	]
	dict.neighbor.hex = [
		[
			Vector2( 1,-1), 
			Vector2( 1, 0), 
			Vector2( 0, 1), 
			Vector2(-1, 0), 
			Vector2(-1,-1),
			Vector2( 0,-1)
		],
		[
			Vector2( 1, 0),
			Vector2( 1, 1),
			Vector2( 0, 1),
			Vector2(-1, 1),
			Vector2(-1, 0),
			Vector2( 0,-1)
		]
	]


func init_beast() -> void:
	dict.beast = {}
	dict.beast.count = {}
	
	for rank in arr.rank:
		dict.beast.count[rank] = arr.rank.front() + arr.rank.back() - rank

func init_emptyjson() -> void:
	dict.emptyjson = {}
	dict.emptyjson.title = {}
	
	var path = "res://asset/json/.json"
	var array = load_data(path)
	
	for emptyjson in array:
		var data = {}
		
		for key in emptyjson:
			if key != "title":
				data[key] = emptyjson[key]
		
		dict.emptyjson.title[emptyjson.title] = data


func init_node() -> void:
	node.game = get_node("/root/Game")


func init_scene() -> void:
	scene.tamer = load("res://scene/1/tamer.tscn")
	
	scene.arena = load("res://scene/2/arena.tscn")
	
	scene.beast = load("res://scene/3/beast.tscn")
	scene.link = load("res://scene/3/link.tscn")


func init_vec():
	vec.size = {}
	vec.size.letter = Vector2(20, 20)
	vec.size.icon = Vector2(48, 48)
	vec.size.number = Vector2(5, 32)
	vec.size.sixteen = Vector2(16, 16)
	
	vec.size.aspect = Vector2(32, 32)
	vec.size.box = Vector2(100, 100)
	vec.size.bar = Vector2(120, 12)
	
	vec.size.state = Vector2(100, 12)
	vec.size.prestige = Vector2(32, 32)
	
	init_window_size()


func init_window_size():
	vec.size.window = {}
	vec.size.window.width = ProjectSettings.get_setting("display/window/size/viewport_width")
	vec.size.window.height = ProjectSettings.get_setting("display/window/size/viewport_height")
	vec.size.window.center = Vector2(vec.size.window.width/2, vec.size.window.height/2)


func init_color():
	var h = 360.0
	
	color.state = {}
	color.state.vigor = {}
	color.state.vigor.fill = Color.from_hsv(120 / h, 1, 0.9)
	color.state.vigor.background = Color.from_hsv(120 / h, 0.25, 0.9)
	color.state.standard = {}
	color.state.standard.fill = Color.from_hsv(30 / h, 1, 0.9)
	color.state.standard.background = Color.from_hsv(30 / h, 0.25, 0.9)
	color.state.fatigue = {}
	color.state.fatigue.fill = Color.from_hsv(0, 1, 0.9)
	color.state.fatigue.background = Color.from_hsv(0, 0.25, 0.9)



func save(path_: String, data_: String):
	var path = path_ + ".json"
	var file = FileAccess.open(path, FileAccess.WRITE)
	file.store_string(data_)


func load_data(path_: String):
	var file = FileAccess.open(path_, FileAccess.READ)
	var text = file.get_as_text()
	var json_object = JSON.new()
	var parse_err = json_object.parse(text)
	return json_object.get_data()


func get_random_key(dict_: Dictionary):
	if dict_.keys().size() == 0:
		print("!bug! empty array in get_random_key func")
		return null
	
	var total = 0
	
	for key in dict_.keys():
		total += dict_[key]
	
	rng.randomize()
	var index_r = rng.randf_range(0, 1)
	var index = 0
	
	for key in dict_.keys():
		var weight = float(dict_[key])
		index += weight/total
		
		if index > index_r:
			return key
	
	print("!bug! index_r error in get_random_key func")
	return null
