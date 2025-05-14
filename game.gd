extends Node2D  # Or whatever type your root is

var is_game_over = false
@onready var timer_spawner: Timer = $TimerSpawner
@onready var joueurs: Label = %Joueurs
@onready var status: Label = %Status
@onready var timer_initial: Timer = $TimerInitial
@onready var initial_moving_area: ReferenceRect = $InitialMovingArea
@onready var player: CharacterBody2D = $Player
@onready var enemy_spawner: Node2D = $EnemySpawner
@onready var enemy_container: Node2D = $EnemyContainer

func _ready():
	GameManager.game = self
	player.spawn_area = Rect2(initial_moving_area.position.x, initial_moving_area.position.y, 
		initial_moving_area.size.x, initial_moving_area.size.y)
	enemy_spawner.enemy_container = enemy_container

func game_over():
	if is_game_over:
		return
	is_game_over = true
	player.game_over()

func restart():
	var start = load("res://start.tscn")
	get_node("/root/Main").add_child(start.instantiate())
	self.queue_free()

func _process(_delta: float) -> void:
	if(!timer_initial.is_stopped()):
		status.text = "La partie va démarrer dans " + str(timer_initial.time_left).pad_decimals(0)
	
func _on_timer_initial_timeout() -> void:
	joueurs.text = "Echappez aux poissons !"
	status.text = ""
	initial_moving_area.visible = false
	player.spawn_area = enemy_spawner.spawn_area.grow(-20)
	timer_spawner.start()
	
