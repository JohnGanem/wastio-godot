extends CharacterBody2D

@onready var label_game_over: Label = $LabelGameOver
@onready var timer_game_over: Timer = $TimerGameOver
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
var spawn_area: Rect2
var stroke: float = 12         # Stroke (outline) of the bubble (adjust as needed)
var stop_distance: float = 15.0  # Distance threshold for stopping shuffling
var speed: float = 400.0
var radius: float = 20         # Radius of the bubble (adjust as needed)
var red = randf()
var green = randf()
var blue = randf()

# List of bubble textures to choose from
var bubble_textures = [
	preload("res://waste1.png"),
	preload("res://waste2.png")
]



func _ready():
	# Randomize and select a texture
	randomize()
	
	add_to_group("Player")

	sprite_2d.texture = bubble_textures[randi() % bubble_textures.size()]
	sprite_2d.scale = Vector2(radius * 2 / sprite_2d.texture.get_width(), radius * 2 / sprite_2d.texture.get_height())
	
	collision_shape_2d.shape = CircleShape2D.new()
	collision_shape_2d.shape.radius = radius
	
	# Make sure the player draws itself on startup
	queue_redraw()

func game_over():
	label_game_over.visible = true
	timer_game_over.start(2)

func _draw():
	# Draw the circle around the player (visualize the collision)
	draw_circle(Vector2.ZERO, radius + stroke, Color(red, green, blue, 0.4))
	draw_circle(Vector2.ZERO, radius, Color(red, green, blue, 0.3))  # semi-transparent blue circle
	
func _physics_process(delta: float) -> void:
	if(!timer_game_over.is_stopped()):
		return
		
	var mouse_position = get_global_mouse_position()
	var distance_to_cursor = global_position.distance_to(mouse_position)
	var collision : KinematicCollision2D
	
	# If the player is within the stop_distance, don't move
	if distance_to_cursor > stop_distance:
		var direction = (mouse_position - global_position).normalized()
		velocity = direction * speed * delta
		collision = move_and_collide(velocity)
	else:
		collision = move_and_collide(Vector2.ZERO)
	
	if collision:
		var collider = collision.get_collider()
		# If the player collides with an enemy, trigger game over
		if collider.is_in_group("Enemy"):
			GameManager.game.game_over(self)
	
	# Clamp player position within the spawn area
	global_position.x = clamp(global_position.x, spawn_area.position.x, spawn_area.position.x + spawn_area.size.x)
	global_position.y = clamp(global_position.y, spawn_area.position.y, spawn_area.position.y + spawn_area.size.y)

func _on_timer_game_over_timeout():
	GameManager.game.restart()
