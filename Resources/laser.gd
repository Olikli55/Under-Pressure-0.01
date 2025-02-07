extends Node2D
@export var laser_line:Line2D
@onready var end_of_laser: Marker2D = $End_of_laser
@onready var laser_raycast: RayCast2D = $Laser_raycast
var player:CharacterBody2D
const TILESET_SCALE := 1
const TILESET_LENGHT := 64
var laser_lenght = 300

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player = get_parent()



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	var gl_mouse_pos : = get_global_mouse_position()
	var lc_mouse_pos : = get_local_mouse_position()
	if position.distance_to(get_local_mouse_position()) <= laser_lenght and player.in_sub == false :
		global_rotation = global_position.angle_to_point(gl_mouse_pos) + PI*0.5
		if Input.is_action_pressed("left_click"):
			if player.in_sub == false:
				var cell_center = Global.tilemap.map_to_local(Global.tilemap.local_to_map(gl_mouse_pos))
				var distance_from_coll_point = cell_center.distance_to(laser_raycast.get_collision_point())
				laser_line.visible = true
				laser_raycast.enabled = true
				laser_raycast.target_position = lc_mouse_pos
				laser_line.points[0] = end_of_laser.position
				laser_line.points[1] = get_local_mouse_position()
				if distance_from_coll_point < 50:
					Global.mine_cell.emit(gl_mouse_pos)
	if not Input.is_action_pressed("left_click") or not position.distance_to(get_local_mouse_position()) <= laser_lenght :
		laser_line.visible = false
		laser_raycast.enabled = false
		rotation = lerp_angle(rotation,0,0.05)
			
		
		


func angle_to_vector(base_point:Vector2,lenght:int,angle:float) -> Vector2:
	var x = base_point.x + lenght * cos(angle)
	var y = base_point.y + lenght * sin(angle)
	return Vector2(x,y)
