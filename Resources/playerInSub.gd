extends CharacterBody2D
@onready var ladder: Area2D = $"../Collisions/Ladder/Area2D"


const SPEED = 300.0
const JUMP_VELOCITY = -400.0


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	var direction := Input.get_axis("left", "right")
	if direction and not $"../Furniture/Computer".inTerminal:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	for body in ladder.get_overlapping_bodies():
		if body is CharacterBody2D:
			if Input.is_action_pressed("up"):
				velocity.x = 0
				velocity.y = -300
	move_and_slide()
