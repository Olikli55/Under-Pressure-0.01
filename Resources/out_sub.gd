extends CharacterBody2D

@onready var area_2d: Area2D = $Area2D
var player_enter:bool = false
func _ready() -> void:
	Global.save.connect(func(): 
		Global.saveFile["submarine_pos"] = global_position)
	Global.load.connect(func():
		global_position = Global.saveFile["submarine_pos"]
		global_rotation = Global.saveFile["submarine_rotation"]
		print(global_rotation,global_position,"out sub"))


func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_accept") and player_enter:
		Global.save.emit()
		get_tree().change_scene_to_file("res://Resources/in_sub.tscn")
		



func _on_area_2d_body_entered(body: CharacterBody2D) -> void:
	player_enter = true
func _on_area_2d_body_exited(body: CharacterBody2D) -> void:
	player_enter = false
