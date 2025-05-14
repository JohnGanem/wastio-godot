extends CharacterBody2D

var direction: Vector2 = Vector2.ZERO
var time_since_change: float = 0.0

var stroke: float = 20

var radius: float
var speed: float

var moving_area: Rect2

var red = random_hue()
var green = random_hue()
var blue = random_hue()

var xs_bubble_textures = [
	preload("res://xsfish1.png"),
	preload("res://xsfish2.png")
]

var sm_bubble_textures = [
	preload("res://smfish1.png"),
	preload("res://smfish2.png")
]

var md_bubble_textures = [
	preload("res://mdfish1.png"),
	preload("res://mdfish2.png")
]

var lg_bubble_textures = [
	preload("res://lgfish1.png"),
	preload("res://lgfish2.png")
]

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D

func _ready():
	# Randomize and select a texture
	randomize()
	
	add_to_group("Enemy")
	
	speed = randi() % 500 + 30 # From 30 to 500
	radius = randi() % 130 + 20 # From 20 to 150
	
	sprite_2d.texture = chooseFishImage(radius)
	sprite_2d.scale = Vector2(radius * 2 / sprite_2d.texture.get_width(), radius * 2 / sprite_2d.texture.get_width())
	
	collision_shape_2d = $CollisionShape2D
	collision_shape_2d.shape = CircleShape2D.new()
	collision_shape_2d.shape.radius = radius
	
	queue_redraw()

func random_hue():
	return (randi() % 100) / 100.0

func chooseFishImage(size):
	if (size < 35):
		return xs_bubble_textures[randi() % xs_bubble_textures.size()]
	elif (size < 70):
		return sm_bubble_textures[randi() % sm_bubble_textures.size()]
	elif (size < 120):
		return md_bubble_textures[randi() % md_bubble_textures.size()]
	else:
		return lg_bubble_textures[randi() % lg_bubble_textures.size()]

func _draw():
	draw_circle(Vector2.ZERO, radius + stroke, Color(red, green, blue, 0.4))
	draw_circle(Vector2.ZERO, radius, Color(red, green, blue, 0.3))

func _physics_process(delta: float) -> void:
	velocity = direction * speed * delta

	var collision = move_and_collide(velocity)
	if collision && collision.get_collider().is_in_group("Player"): 
		GameManager.game.game_over()
	 # Remove if far outside bounds
	if not moving_area.has_point(global_position):
		queue_free()
	
