extends Node


@export var ball_radius = 32
var ball = preload("res://ball.tscn")

var balls = []

# Called when the node enters the scene tree for the first time.
func _ready():
    for i in range(5):
        var b = ball.instantiate()
        add_child(b)
        b.position = Vector2(i * ball_radius, 10)
        balls.append(b)

func check_collided(ball1, ball2):
    var distance = ball1.position.distance_to(ball2.position)
    if distance < ball_radius * 2:
        return true
    else:
        return false

func _physics_process(delta):
    # check collision
    for i in range(balls.size()):
        for j in range(i + 1, balls.size()):
            if check_collided(balls[i], balls[j]):
                print("collision")



