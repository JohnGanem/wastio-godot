extends Node2D

@export var enemy_scene : PackedScene  # Drag the Enemy scene into this export
@export var spawn_area: Rect2 = Rect2(Vector2(-2000, -2000), Vector2(4000, 4000))  # Area within which to spawn enemies
@onready var moving_area: ReferenceRect = $MovingArea

var max_enemy: int = 100
var enemy_container: Node2D

func _ready() -> void:
	moving_area.custom_minimum_size.x = spawn_area.size.x
	moving_area.custom_minimum_size.y = spawn_area.size.y
	
func spawn_enemy():
	if !enemy_container:
		return
	
	# Get a random position within the spawn area
	var spawn_position: Vector2
	var target_direction: Vector2
	
	var distance_from_border = 500
	var angle_direction = 2
	match randi() % 4:
		0: # Top
			spawn_position = Vector2(randf_range(spawn_area.position.x, spawn_area.position.x + spawn_area.size.x), spawn_area.position.y - distance_from_border)
			target_direction = Vector2(randf_range(-angle_direction, angle_direction), 1)
		1: # Bottom
			spawn_position = Vector2(randf_range(spawn_area.position.x, spawn_area.position.x + spawn_area.size.x), spawn_area.position.y + spawn_area.size.y + distance_from_border)
			target_direction = Vector2(randf_range(-angle_direction, angle_direction), -1)
		2: # Left
			spawn_position = Vector2(spawn_area.position.x - distance_from_border, randf_range(spawn_area.position.y, spawn_area.position.y + spawn_area.size.y))
			target_direction = Vector2(1, randf_range(-angle_direction, angle_direction))
		3: # Right
			spawn_position = Vector2(spawn_area.position.x + spawn_area.size.x + distance_from_border, randf_range(spawn_area.position.y, spawn_area.position.y + spawn_area.size.y))
			target_direction = Vector2(-1, randf_range(-angle_direction, angle_direction))
		
	# Instance a new enemy
	var enemy = enemy_scene.instantiate()
	enemy.position = spawn_position
	enemy.direction = target_direction.normalized()
	enemy.moving_area = spawn_area.grow(distance_from_border+100)
	
	# Add the enemy to the scene
	enemy_container.add_child(enemy)

func _on_timer_spawner_timeout():
	var enemy_left_to_spawn = max_enemy - enemy_container.get_child_count()
	var enemy_to_spawn = 5 if enemy_left_to_spawn > 5 else enemy_left_to_spawn
	for n in enemy_to_spawn:
		spawn_enemy()
