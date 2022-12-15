extends Node2D

func _ready():
	Globals.connect("tank_start", self, "on_tank_start")
	Globals.connect("tank_stop", self, "on_tank_stop")
	Globals.connect("tank_position", self, "on_tank_position")

func _input(event: InputEvent):
	var mouse_event = event as InputEventMouseButton
	if not mouse_event:
		return
	if mouse_event.pressed and mouse_event.button_index == BUTTON_LEFT:
		Globals.emit_signal("click", mouse_event.position)

func on_tank_start(from: Vector2, to: Vector2):
	$Line2D.points = [from, to]

func on_tank_stop():
	$Line2D.points = []

func on_tank_position(pos: Vector2):
	if $Line2D.points.size() == 2:
		$Line2D.points = [pos, $Line2D.points[1]]
