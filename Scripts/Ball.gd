extends RigidBody2D

onready var Game = get_node("/root/Game")
onready var Starting = get_node("/root/Game/Starting")

var _max_offset = 4
var _decay_rate = 0.0
var _start_size
var _start_position
var _trauma = 0.0
var _rotation = 0
var _rotation_speed = 0.05
var _color = 0.0
var _color_decay = 1
var _normal_color

func _ready():
	contact_monitor = true
	set_max_contacts_reported(4)
	_start_position = $ColorRect.rect_position
	_start_size = $ColorRect.get_transform().size
	_normal_color = $ColorRect.color

func _physics_process(delta):
	# Check for collisions
	var bodies = get_colliding_bodies()
	for body in bodies:
		if body.is_in_group("Tiles"):
			Game.change_score(body.points)
			body.queue_free()
	
	if position.y > get_viewport().size.y:
		Game.change_lives(-1)
		Starting.startCountdown(3)
		queue_free()
		

func add_trauma(amount):
	_trauma = min(_trauma + amount, 1)

func _decay_trauma(delta):
	var change = _decay_rate * delta
	_trauma = max(_trauma - change, 0)

func _apply_shake():
	var shake = _trauma * _trauma
	var 0_x = _max_offset * shake * _get_neg_or_pos_scalar()
	var 0_y = _max_offset * shake * _get_neg_or_pos_scalar()
	$ColorRect.rect_position = _start_position * Vector2(0_x, 0_y)

func _get_neg_or_pos_scalar():
	return rand_range(-1,0, 1,0)
