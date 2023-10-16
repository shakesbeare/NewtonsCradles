extends Node

signal start_angle(int, float)

var newton_ball = preload("res://newton_ball.tscn")
var number_balls: int = 5
var newton_balls = []

# Called when the node enters the scene tree for the first time.
func _ready():
    for i in range(number_balls):
        var b = newton_ball.instantiate() # Node2D
        add_child(b)
        b.position = Vector2(i * 64, 0)
        newton_balls.append(b)

        if i > 2:
            start_angle.emit(i, 0)
        else:
            start_angle.emit(i, 45)

    Engine.set_physics_ticks_per_second(1000)


func collision():
    # 0 1 . 1 2 . 2 3 . 3 4
    # 1 0 . 2 1 . 3 2 . 4 3
    # async???

    for i in range(number_balls -1):
        var apparatus1 = newton_balls[i]
        var top_connector1 = apparatus1.get_node("top connector")
        var apparatus2 = newton_balls[i + 1]
        var top_connector2 = apparatus2.get_node("top connector")

        var ball1_pos = Vector2(96 * sin(-top_connector1.rotation), 96 * cos(-top_connector1.rotation)) + apparatus1.position
        var ball2_pos = Vector2(96 * sin(-top_connector2.rotation), 96 * cos(-top_connector2.rotation)) + apparatus2.position

        var distance = (ball2_pos - ball1_pos).length()

        if distance <= 64:
            # set the distance = 64 and update the rotations
            var angle = (top_connector1.rotation + top_connector2.rotation) / 2
            top_connector1.rotation = angle
            top_connector2.rotation = angle

            var temp = top_connector1.angular_velocity
            top_connector1.angular_velocity = top_connector2.angular_velocity
            top_connector2.angular_velocity = temp

            if top_connector1.angular_velocity < 0.0001:
                top_connector1.angular_velocity = 0
            elif top_connector2.angular_velocity < 0.0001:
                top_connector2.angular_velocity = 0


func _physics_process(delta):
    # loop through all the newton_balls
    # if any positions overlap (distance from center to center >= 64)
    # then, collide

    collision()




