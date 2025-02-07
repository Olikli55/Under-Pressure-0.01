extends Node2D

var map_size = Global.radarLenght
@onready var area_2d: Area2D = $ExitArea
var player_enter:bool = false
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_accept") and player_enter:
		print("i wnat to go the the radar")
		get_tree().change_scene_to_file("res://Resources/level.tscn")
		return

func _on_area_2d_body_entered(body: CharacterBody2D) -> void:
	player_enter = true
func _on_area_2d_body_exited(body: CharacterBody2D) -> void:
	player_enter = false


func load_terrain() -> void:
	for x in range(-(map_size*0.5),(map_size*0.5),1):
		for y in range(-(map_size*0.5),(map_size*0.5),1):
			var pos = Vector2i(x,y)
