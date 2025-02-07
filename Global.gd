extends Node

signal mine_cell(pos:Vector2)
signal add_to_inventory(item:String)
signal save
signal load
var CHUNK_SIZE = 16
var radarLenght = 50/2
var mapSize:int = 100
var saveFile:Dictionary = {
		"terrain_layer": [],
		"terrain_size": Rect2i(),
		"ore_layer": [],
		"player_pos":[],
		"submarine_pos":Vector2(),
		"submarine_rotation":float(),
		}
var tilemap:TileMapLayer
