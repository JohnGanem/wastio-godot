extends CanvasLayer

@onready var network = get_node("/root/Main/NetworkManager")

func _ready():
	$%HostButton.pressed.connect(_on_host_pressed)
	$%JoinButton.pressed.connect(_on_join_pressed)

func _on_host_pressed():
	network.host_game()

func _on_join_pressed():
	network.join_game("127.0.0.1")  # For now, use local IP

func _on_play_pressed():
	var game = load("res://game.tscn")
	get_node("/root/Main").add_child(game.instantiate())
	self.queue_free()
