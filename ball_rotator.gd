class_name BallRotator
extends Node2D

static var last_id: int = 0

@export var ball: Node2D

var id: int
var angular_velocity: float:
	get:
		return angular_momentum / I
	set(value):
		angular_momentum = I * value

var torque: float
var angular_momentum: float
var period: float

var R: float = 1:
	set(_v):
		period = 2 * PI * sqrt(R / Physics.g)

var I = a * M * R ** 2

# T = -R(mg sin(theta) )
const M: float = 1  # M should cancel, but here add a parameter to test it
const a: float = 1


func _init():
	self.id = last_id
	last_id += 1


func _ready():
	var bm = get_tree().get_root().get_node("/root/Node2D/BallManager")
	bm.start_angle.connect(_on_set_angle)
	bm.reset.connect(_on_reset)

	period = 2 * PI * sqrt(R / Physics.g)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	# handle acceleration due to gravity
	# https://pressbooks.online.ucf.edu/phy2048tjb/chapter/15-4-pendulums/
	torque = -R * (M * Physics.g * sin(self.rotation))
	var angular_acceleration = torque / I  # torque = I * angular_acceleration
	var d_omega = angular_acceleration * delta
	angular_velocity += d_omega

	self.rotation += angular_velocity * delta


func _on_set_angle(i: int, angle: float):
	if self.id == i:
		self.rotation_degrees = angle


func _on_rope_rope_length(r: float):
	R = r


func _on_reset():
	self.rotation = 0
	self.angular_velocity = 0
	self.angular_momentum = 0
