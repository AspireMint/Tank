extends KinematicBody2D

onready var move_to: Vector2 = transform.origin
onready var move_to_rotation: float = $Body.global_rotation

const move_speed: int = 100
const rotation_speed: Dictionary = {
	body = 10,
	turret = 5
}
const rotation_threshold: float = 0.01

func _ready():
	Globals.connect("click", self, "on_click")

func _process(delta):
	if is_rotating():
		$Body.global_rotation = lerp_angle($Body.global_rotation, move_to_rotation, rotation_speed.body * delta)
		$Turret.global_rotation = lerp_angle($Turret.global_rotation, move_to_rotation, rotation_speed.turret * delta)
	else:
		$Body.global_rotation = move_to_rotation
		$Turret.global_rotation = move_to_rotation
		move_tank(delta)

func is_rotating() -> bool:
	if abs($Body.global_rotation - move_to_rotation) > rotation_threshold:
		return true
	if abs($Turret.global_rotation - move_to_rotation) > rotation_threshold:
		return true
	return false

func move_tank(delta) -> void:
	var pos = transform.origin
	var dist = move_to.distance_to(pos)
	
	if dist == 0:
		return
	
	var walk_dir = pos.direction_to(move_to)
	var step = walk_dir * delta * move_speed
	var step_length = step.distance_to(Vector2.ZERO)
	
	if dist < step_length:
		transform.origin = move_to
		Globals.emit_signal("tank_stop")
	else:
		transform.origin += step
	Globals.emit_signal("tank_position", transform.origin)

func on_click(position: Vector2):
	if is_rotating():
		return
	move_to = position
	move_to_rotation = move_to.angle_to_point(transform.origin)
	Globals.emit_signal("tank_start", transform.origin, move_to)
