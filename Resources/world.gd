extends Node2D

@export var ore_layer:TileMapLayer
@export var water_layer:TileMapLayer
@export var terrain_layer:TileMapLayer
var loadedChunks:Array[Vector2i] = []
var map_size = Global.mapSize
var terrain_cells_arr:Array[Vector2i]
var CHUNK_SIZE
var curentChunk:Vector2
var previusChunk:Vector2
var RENDER_DISTANCE = 3
func _ready() -> void:
	CHUNK_SIZE = Global.CHUNK_SIZE 
	Global.mine_cell.connect(mine_cell)
	Global.save.connect(saveTileMap)
	Global.load.connect(loadTileMap)
	Global.tilemap = terrain_layer
	if Global.saveFile["terrain_layer"]:
		call_deferred("_emit_save_signal")
	else:
		pass
		#generate_world()
	generateChunk(Vector2i(-1,0))
	generateChunk(Vector2i(1,0))
func _emit_save_signal():
	Global.load.emit()
func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("save"):
		Global.save.emit()
	if Input.is_action_just_pressed("load"):
		loadTileMap()
	if Input.is_action_just_pressed("switchScene"):
		get_parent().get_tree().change_scene_to_file("res://Resources/radar.tscn")
	generateChunkAroundPlayer()

func mine_cell(pos:Vector2) -> void:
	var map_pos := terrain_layer.local_to_map(pos)
	if not terrain_layer.get_cell_source_id(map_pos) == -1:
		terrain_layer.erase_cell(map_pos)
	if not ore_layer.get_cell_source_id(map_pos) == -1:
		match ore_layer.get_cell_atlas_coords(map_pos):
			Vector2i(0,0):
				Global.add_to_inventory.emit("iron")
			Vector2i(1,0):
				Global.add_to_inventory.emit("iron")
		ore_layer.erase_cell(map_pos)
	for cell in terrain_layer.get_surrounding_cells(map_pos):
		if not terrain_layer.get_cell_source_id(cell) == -1:
			terrain_layer.set_cell(cell,1,terrain_layer.get_cell_atlas_coords(cell))
	for cell in ore_layer.get_surrounding_cells(map_pos):
		if not ore_layer.get_cell_source_id(cell) == -1:
			ore_layer.set_cell(cell,1,ore_layer.get_cell_atlas_coords(cell))

func generate_world() -> void:
	for x in range(-(map_size*0.5),(map_size*0.5),CHUNK_SIZE):
		for y in range(-(map_size*0.5),(map_size*0.5),CHUNK_SIZE):
			generateChunk(Vector2i(x,y))
	terrain_layer.set_cells_terrain_connect(terrain_cells_arr,0,0)

func saveTileMap() -> void:
	var saveTerrain_size:Rect2 = water_layer.get_used_rect()
	Global.saveFile["terrain_size"] = saveTerrain_size
	var start = saveTerrain_size.position
	var stop = saveTerrain_size.size - Vector2(map_size/2,map_size/2)
	var terrainLayer:Array = []
	for x in range(start.x,stop.x):
		var collum:Array = []
		for y in range(start.y,stop.y):
			var pos := Vector2(x,y)
			var source_id := terrain_layer.get_cell_source_id(pos)
			var atlas_pos :Vector2 = terrain_layer.get_cell_atlas_coords(pos)
			collum.append([source_id,atlas_pos])
		terrainLayer.append(collum)
	Global.saveFile["terrain_layer"] = terrainLayer
 
func loadTileMap():
	var saveFile:Dictionary = Global.saveFile
	var saveTerrain_size:Rect2 = Global.saveFile["terrain_size"]
	if not saveFile or not saveFile.has("ore_layer") or not saveFile.has("terrain_layer"):
		print("Error: Invalid save file data")
		get_parent().get_tree().quit()
		return
	var start = saveTerrain_size.position
	var stop = saveTerrain_size.size - Vector2(map_size/2,map_size/2)

	for x in range(len(saveFile["terrain_layer"])):  
		for y in range(len(saveFile["terrain_layer"][x])):
			var pos: = Vector2i(x,y)
			var listLenght = len(saveFile["terrain_layer"][0]) / 2 
			var listhight = len(saveFile["terrain_layer"]) / 2 
			var cell : Array = saveFile["terrain_layer"][pos.x][pos.y]
			var source_id:int #= saveFile["ore_layer"][y][x]
			#ore_layer.set_cell(Vector2i(x,y), source_id)
			source_id = cell[0]
			var atlas_pos : Vector2i = cell[1]
			terrain_layer.set_cell(pos-Vector2i(listLenght,listhight), source_id,atlas_pos)
			water_layer.set_cell(pos-Vector2i(listLenght,listhight),0,Vector2i(3,0))

func generateChunk(chunk:Vector2i):
	loadedChunks.append(chunk)
	var terrain_cells_arr:Array[Vector2i] = []
	for x in range(CHUNK_SIZE):
		for y in range(CHUNK_SIZE):
			var cellPos := Vector2i(x,y) + chunk * Vector2i(CHUNK_SIZE,CHUNK_SIZE)
			water_layer.set_cell(cellPos,0,Vector2i(3,0))
			var terrain_noise_val = terrain_layer.noise.get_noise_2d(cellPos.x,cellPos.y)
			var ore_noise_val = ore_layer.noise.get_noise_2d(cellPos.x,cellPos.y)
			if terrain_noise_val > 0:
				terrain_cells_arr.append(cellPos)
				if ore_noise_val > 0.41:
					ore_layer.set_cell(cellPos,0,Vector2i(0,0),0)
	terrain_layer.set_cells_terrain_connect(terrain_cells_arr,0,0)

func tilePositionToChunk(pos:Vector2i) -> Vector2i:
	var chunk:Vector2i
	chunk.x = int(pos.x / CHUNK_SIZE)
	chunk.y = int(pos.y / CHUNK_SIZE)
	if pos.x < 0:
		chunk.x -= 1
	if pos.y < 0:
		chunk.y -= 1
	return chunk

func generateChunkAroundPlayer() -> void:
	var playerPosTile:Vector2i = terrain_layer.local_to_map($"../Player".global_position)
	curentChunk = tilePositionToChunk(playerPosTile)
	if curentChunk != previusChunk:
		for x in range(RENDER_DISTANCE):
			x -= RENDER_DISTANCE/2
			for y in range(RENDER_DISTANCE):
				y -= RENDER_DISTANCE/2
				var chunk:Vector2i = tilePositionToChunk(playerPosTile) - Vector2i(x,y)
				if not chunk in loadedChunks:
					generateChunk(chunk)
	previusChunk = curentChunk
