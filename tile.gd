extends Node

class_name Tile

signal explode
signal show
signal user_show(x, y)

var x: int = 0
var y: int = 0

var mine: bool = false
var flag: bool = false
var hidden: bool = true
var count: int = 0

var textures = {}

func _ready():
	var button = get_node(".")
	var size = 32
	button.rect_min_size = Vector2(size, size)
	button.expand = true
	var sprite = get_node("Layer2Sprite")
	sprite.region_rect = Rect2(Vector2(0, 0), Vector2(size, size))
	
	var filenames = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "empty", "flag", "hidden", "mine"]
	
	textures = {}
	for filename in filenames:
		var tex = ImageTexture.new()
		var filepath = "assets/%s.png" % filename
		tex.load(filepath)
		textures[filename] = tex
		
	update_tex()

func set_ids(x_: int, y_: int):
	x = x_
	y = y_

func reset():
	mine = false
	flag = false
	hidden = true
	count = 0
	update_tex()

func show_tile():
	if not flag and hidden:
		force_show()
		if mine:
			emit_signal("explode")
		else:
			emit_signal("user_show", x, y)

func force_show():
	hidden = false
	flag = false
	update_tex()
	emit_signal("show")

func tag_tile():
	if hidden:
		flag = not flag
		update_tex()
		
func update_tex():
	var button = get_node(".")
	
	if hidden:
		button.texture_normal = textures["hidden"]
		if flag:
			$Layer2Sprite.texture = textures["flag"]
		else:
			$Layer2Sprite.texture = null
	else:
		button.texture_normal = textures["empty"]
		if mine:
			$Layer2Sprite.texture = textures["mine"]
		elif 0 < count and count <= 9:
			$Layer2Sprite.texture = textures[str(count)]
		elif count == 0:
			$Layer2Sprite.texture = null
		else:
			print("ERROR")

func _gui_input(event):
	if event is InputEventMouseButton and event.pressed: 
		# print("Mouse evt ", hidden, flag, mine)
		if event.button_index == BUTTON_LEFT:
			show_tile()
		elif event.button_index == BUTTON_RIGHT:
			tag_tile()
