class_name Rope
extends Sprite2D

signal rope_length(float)

const sprite_height: float = 64

@export var length: float = 2
@export var ball: Node2D
@export var bottom_connector: Node2D


func _ready():
	self.scale = Vector2(1, length)
	ball.scale = Vector2(1, 1 / length)

	self.position.y = sprite_height * length / 2
	bottom_connector.position.y = sprite_height * length / 2
	ball.position.y = 32

	rope_length.emit(length)
