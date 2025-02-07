extends Node2D
var playerIn:bool = false
func _process(delta: float) -> void:
	if playerIn and Input.is_action_just_pressed("ui_accept"):
		Global.save.emit()
		get_parent().get_parent().get_tree().change_scene_to_file("res://Resources/radar.tscn")




func _on_area_2d_body_entered(body: CharacterBody2D) -> void:
	playerIn = true
func _on_area_2d_body_exited(body: CharacterBody2D) -> void:
	playerIn = false
