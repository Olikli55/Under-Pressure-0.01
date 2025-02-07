extends TileMapLayer
var RadarTilesRange:int = Global.radarLenght
@onready var submarine: CharacterBody2D = $"../Submarine"
var RENDER_DISTANCE = 5
var curentChunk:Vector2i
var previusChunk:Vector2i
var loadedChunks:Array[Vector2i]
var CHUNK_SIZE
@export var noise_hight_texture_terrain:NoiseTexture2D
@onready var noise:Noise = noise_hight_texture_terrain.noise
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	CHUNK_SIZE = Global.CHUNK_SIZE
	get_parent()
	generateChunksAroundPlayer(local_to_map(submarine.global_position))
func _process(delta: float) -> void:
	var subPosTile:Vector2i = local_to_map(submarine.global_position)
	curentChunk = tilePositionToChunk(subPosTile)
	if curentChunk != previusChunk:
		generateChunksAroundPlayer(subPosTile)
	previusChunk = curentChunk

func generateChunksAroundPlayer(subPosTile:Vector2i) -> void:
	for x in range(RENDER_DISTANCE):
		x -= RENDER_DISTANCE/2
		for y in range(RENDER_DISTANCE):
			y -= RENDER_DISTANCE/2
			var chunk:Vector2i = tilePositionToChunk(subPosTile) - Vector2i(x,y)
			if not chunk in loadedChunks:
				generateChunk(chunk)
				print(chunk)
	
	
func tilePositionToChunk(pos:Vector2i) -> Vector2i:
	var chunk:Vector2i
	chunk.x = int(pos.x / CHUNK_SIZE)
	chunk.y = int(pos.y / CHUNK_SIZE)
	if pos.x < 0:
		chunk.x -= 1
	if pos.y < 0:
		chunk.y -= 1
	return chunk
	
func generateChunk(chunk:Vector2i):
	loadedChunks.append(chunk)
	var terrain_cells_arr:Array[Vector2i] = []
	for x in range(CHUNK_SIZE):
		for y in range(CHUNK_SIZE):
			var cellPos := Vector2i(x,y) + chunk * Vector2i(CHUNK_SIZE,CHUNK_SIZE)
			var terrain_noise_val = noise.get_noise_2d(cellPos.x,cellPos.y)
			if terrain_noise_val > 0:
				set_cell(cellPos,0,Vector2i(1,1))
	
#func LoadSurroundingCells() ->void:	
	#var saveFile:Dictionary = Global.saveFile
	#if not saveFile["terrain_layer"].size() > 0:
		#push_error("Error: Invalid save file data")
		#get_parent().get_tree().quit()
		#return
	#var subPos = Global.saveFile["submarine_pos"]
	#submarine.position = subPos
	#var subTilePos = local_to_map(subPos)
	#for x in range(subTilePos.x - RadarTilesRange, subTilePos.x  + RadarTilesRange,1):
		#for y in range(subTilePos.y - RadarTilesRange, subTilePos.y + RadarTilesRange,1):
			##creates an offset bc i cant put an -1 in a list
			#var listPos = Vector2i(x + Global.mapSize*0.5, y + Global.mapSize*0.5)
			#if not saveFile["terrain_layer"][listPos.x][listPos.y][0] == -1:
				#set_cell(Vector2(x,y),0,Vector2i(1,1))
