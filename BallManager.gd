extends Node

signal start_angle(int, float)
signal reset

var newton_ball = preload("res://newton_ball.tscn")
var number_balls: int = 5
var newton_balls = []
var clicked_on: int = -1


# Called when the node enters the scene tree for the first time.
func _ready():
	for i in range(number_balls):
		var b = newton_ball.instantiate()  # Node2D
		add_child(b)
		b.position = Vector2(i * 64, 0)
		newton_balls.append(b)

		if i > 0:
			start_angle.emit(i, 0)
		else:
			start_angle.emit(i, 45)

	Engine.set_physics_ticks_per_second(1000)


func collision():
	# 0 1 . 1 2 . 2 3 . 3 4
	# 1 0 . 2 1 . 3 2 . 4 3
	# async???

	for i in range(number_balls - 1):
		var apparatus = newton_balls[i]
		var top_connector = apparatus.get_node("top connector")
		var apparatus2 = newton_balls[i + 1]
		var top_connector2 = apparatus2.get_node("top connector")

		var ball1_pos = (
			Vector2(
				96 * sin(-top_connector.rotation),
				96 * cos(-top_connector.rotation)
			)
			+ apparatus.position
		)
		var ball2_pos = (
			Vector2(
				96 * sin(-top_connector2.rotation),
				96 * cos(-top_connector2.rotation)
			)
			+ apparatus2.position
		)

		var distance = (ball2_pos - ball1_pos).length()

		if distance <= 64:
			# set the distance = 64 and update the rotations
			var sign1 = top_connector.rotation / abs(top_connector.rotation)
			var sign2 = top_connector2.rotation / abs(top_connector2.rotation)
			if sign1 < 0:
				top_connector.rotation = top_connector2.rotation
			else:
				top_connector2.rotation = top_connector.rotation

			var temp = top_connector.angular_velocity
			top_connector.angular_velocity = top_connector2.angular_velocity
			top_connector2.angular_velocity = temp

			if abs(top_connector.angular_velocity) < 0.001:
				top_connector.angular_velocity = 0

			if abs(top_connector2.angular_velocity) < 0.001:
				top_connector2.angular_velocity = 0


func _physics_process(_delta):
	# loop through all the newton_balls
	# if any positions overlap (distance from center to center >= 64)
	# then, collide

	collision()


func _input(event):
	if event.is_action_pressed("one"):
		reset.emit()
		start_angle.emit(0, 45)
	elif event.is_action_pressed("two"):
		reset.emit()
		for i in range(2):
			start_angle.emit(i, 45)
	elif event.is_action_pressed("three"):
		reset.emit()
		for i in range(3):
			start_angle.emit(i, 45)
	elif event.is_action_pressed("four"):
		reset.emit()
		for i in range(4):
			start_angle.emit(i, 45)
	elif event.is_action_pressed("five"):
		reset.emit()
		for i in range(5):
			start_angle.emit(i, 45)
	elif event.is_action_pressed("reset"):
		for i in range(number_balls):
			reset.emit()
