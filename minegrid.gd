extends Node

var nb_lines = 20
var nb_columns = 40
var nb_tiles_shown = 0
var nb_mines = 0
var pos_to_idx = {}


func _ready():
	randomize()
	print("Start MineGrid !")
	
	var reset_button = get_node("VBoxContainer/ResetButton")
	reset_button.connect("pressed", self, "on_reset")
	
	var tile_scene = preload("res://tile_scene.tscn")
	var grid_container = get_node("VBoxContainer/GridContainer")
	
	print("Init grid of size (%d, %d)" % [nb_lines, nb_columns])
	grid_container.set_columns(nb_columns)
	
	var count = 0
	for i in range(nb_lines):
		for j in range(nb_columns):
			var tile = tile_scene.instance()
			tile.set_ids(i, j)
			grid_container.add_child(tile)
			
			tile.connect("explode", self, "on_explode")
			tile.connect("user_show", self, "on_user_show")
			# var tile_button = tile.get_node(".")
			# tile.connect("show", self, "on_show")
			# tile_button.connect("pressed", self, "on_pressed", [tile.x, tile.y])
			
			pos_to_idx[[i, j]] = count
			count += 1
	
	self.on_reset()

func _process(_delta):
	if Input.is_key_pressed(KEY_ESCAPE):
		get_tree().quit()
		
func get_tile(x: int, y: int) -> Node:
	var grid_container = get_node("VBoxContainer/GridContainer")
	var idx = pos_to_idx[[x, y]]
	return grid_container.get_child(idx)

func get_neighbours(x: int, y: int) -> Array:
	var neighbours = []
	for i in [x-1, x, x+1]:
		for j in [y-1, y, y+1]:
			if 0 <= i  and i < nb_lines and 0 <= j and j < nb_columns and not(i == x and j == y):
				var tile = get_tile(i, j)
				neighbours.append(tile)			
	return neighbours

func update_global_tiles_shown():
	nb_tiles_shown = 0
	for i in range(nb_lines):
		for j in range(nb_columns):
			var tile = get_tile(i, j)
			if not tile.hidden:
				nb_tiles_shown += 1

func check_win():
	update_global_tiles_shown()
	if nb_tiles_shown + nb_mines == nb_lines * nb_columns:
		on_win()

func show_all():
	for i in range(nb_lines):
		for j in range(nb_columns):
			var tile = get_tile(i, j)
			tile.force_show()
	
func on_reset():
	nb_tiles_shown = 0
	$Panel.visible = false
	$TexVictoire.visible = false
	$TexGameOver.visible = false

	# Reset tiles
	for i in range(nb_lines):
		for j in range(nb_columns):
			var tile = get_tile(i, j)
			tile.reset()
	
	# Place mines
	nb_mines = (nb_lines * nb_columns) / 10
	for _i in range(nb_mines):
		var ok = false
		var tile = null
		while not ok:
			var rd_x = randi() % nb_lines
			var rd_y = randi() % nb_columns
			tile = get_tile(rd_x, rd_y)
			ok = not tile.mine
		tile.mine = true
	
	# Init mine neighbours counts for each tile
	for i in range(nb_lines):
		for j in range(nb_columns):
			var tile = get_tile(i, j)
			if not tile.mine:
				var neighbours = get_neighbours(i, j)
				for neighbour in neighbours:
					if neighbour.mine:
						tile.count += 1

func on_win():
	print("VICTOIRE !")
	show_all()
	$Panel.visible = true
	$TexVictoire.visible = true
	
func on_explode():
	print("GAME OVER")
	show_all()
	$Panel.visible = true
	$TexGameOver.visible = true

func on_user_show(x: int, y: int):
	print("Pressed: %d %d" % [x, y])
	var first_tile = get_tile(x, y)
	
	if not first_tile.mine and first_tile.count == 0:
		var queue = [first_tile]
		var visited = []
		
		while not queue.empty():
			var tile = queue.back()
			tile.force_show()
			queue.pop_back()
			if tile.count == 0:
				var neighbours = get_neighbours(tile.x, tile.y)
				for neighbour in neighbours:
					if not(neighbour in queue or neighbour in visited):
						queue.append(neighbour)
				visited.append(tile)
	
	check_win()

func on_show(_x: int, _y: int):
	nb_tiles_shown += 1
