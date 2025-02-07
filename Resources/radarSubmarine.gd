extends CharacterBody2D

@export var speed: float = 200
@export var friction: float = 0.05
@export var acceleration: float = 0.1
@export var rotation_speed: float = 0.006

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		Global.saveFile["submarine_pos"] = global_position
		Global.saveFile["submarine_rotation"] = global_rotation
		print(global_rotation,global_position)
		get_parent().get_tree().change_scene_to_file("res://Resources/in_sub.tscn")

func get_input():
	var input = Vector2()
	# Handle rotation
	if Input.is_action_pressed('right'):
		rotate(rotation_speed)
	if Input.is_action_pressed('left'):
		rotate(-rotation_speed)
	if Input.is_action_pressed('down'):
		input.y += 1
	if Input.is_action_pressed('up'):
		input.y -= 1
	
	return input

func _physics_process(_delta):
	var input = get_input()
	var movement_direction = transform.x * (-input.y)
	if movement_direction.length() > 0:
		velocity = velocity.lerp(movement_direction.normalized() * speed, acceleration)
	else:
		velocity = velocity.lerp(Vector2.ZERO, friction)
	
	move_and_slide()
