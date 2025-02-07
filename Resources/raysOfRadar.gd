extends Node2D

var radar:bool = true
var lenght:int = Global.radarLenght*64
func _ready() -> void:
	for i in range(0,360*2,1):
		var raycast:RayCast2D = RayCast2D.new()
		raycast.target_position = convert_to_vector(lenght, Vector2(0,0),deg_to_rad(i*0.5))
		raycast.collision_mask = 2
		var radarDot:Sprite2D = Sprite2D.new()
		radarDot.texture = load("res://Assets/radarDot.png")
		radarDot.scale = Vector2(0.5,0.5)
		raycast.add_child(radarDot)
		add_child(raycast)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	for ray in get_children():
		if ray is RayCast2D:
			var collisionPos:Vector2 = ray.get_collision_point()
			var radarDot:Sprite2D = ray.get_child(0)
			if not collisionPos == Vector2.ZERO and radar:
				radarDot.visible = true
				radarDot.global_position = collisionPos
			if radarDot.global_position.distance_to(ray.global_position) > lenght or collisionPos == Vector2.ZERO or not radar :
				radarDot.visible = false
				radarDot.global_position = Vector2.ZERO

func convert_to_vector(length: float, base_point: Vector2, rotation: float) -> Vector2:
	var x = length * cos(rotation)
	var y = length * sin(rotation)
	return Vector2(base_point.x + x, base_point.y + y)
