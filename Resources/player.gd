extends CharacterBody2D

@export var speed:float = 400
@export var friction:float = 0.1
@export var acceleration:float = 0.1
@export var rotation_speed:float = 0.03
@export var my_camera:Camera2D
@export var subSpawnpoint:Marker2D
var target_rotation:float = 0
@onready var point_light_2d: PointLight2D = $PointLight2D


var in_sub:bool
func _ready() -> void:
	Global.save.connect(func():Global.saveFile["player_pos"] = global_position)
	Global.load.connect(func():global_position = subSpawnpoint.global_position)
func get_input():
	var input = Vector2()
	if Input.is_action_pressed('right'):
		input.x += 1
	if Input.is_action_pressed('left'):
		input.x -= 1
	if Input.is_action_pressed('down'):
		input.y += 1
	if Input.is_action_pressed('up'):
		input.y -= 1
	return input
func _physics_process(_delta):
	var direction = get_input()
	handle_player_and_light_rotation(direction)
	if direction.length() > 0:
		velocity = velocity.lerp(direction.normalized() * speed, acceleration)
	else:
		velocity = velocity.lerp(Vector2.ZERO, friction)
	move_and_slide()
func handle_player_and_light_rotation(direction:Vector2) -> void:
	if direction != Vector2.ZERO:
		target_rotation =  Vector2.ZERO.angle_to_point(direction)+PI*0.5
	rotation = lerp_angle(rotation,target_rotation,rotation_speed)
