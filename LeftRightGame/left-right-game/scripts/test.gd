extends Control

enum state { game_start, game_in_progress, game_finished }
var currentState = state.game_start

func _ready():
	print("test.gd ready")

func _process(_delta):
	inputControl()

func inputControl():
	if Input.is_action_just_pressed("game_action_left"):
		print("Left")
	if Input.is_action_just_pressed("game_action_right"):
		print("Right")
