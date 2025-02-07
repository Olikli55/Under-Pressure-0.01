extends TileMapLayer

var map_size = 100
var terrain_cells_arr:Array
@export var noise_hight_texture_terrain:NoiseTexture2D
@onready var noise:Noise = noise_hight_texture_terrain.noise
# Called when the node enters the scene tree for the first time.
