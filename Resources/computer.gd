extends Node2D
var playerIn:bool = false
var inTerminal:bool = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if playerIn and Input.is_action_just_pressed("ui_accept") and not inTerminal:
		$CanvasLayer/Terminal.visible = true
		print("in")
		inTerminal = true
	if inTerminal and Input.is_action_just_pressed("ui_cancel"):
		inTerminal = false
		$CanvasLayer/Terminal.visible = false
		print("outt")







func _on_area_2d_body_entered(body: CharacterBody2D) -> void:
	playerIn = true
func _on_area_2d_body_exited(body: CharacterBody2D) -> void:
	playerIn = false
