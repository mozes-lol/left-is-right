extends Control

enum game_state { game_start, game_in_progress, game_finished }
var currentState = game_state.game_start

var direction = ["Left", "Right"]
var direction_needed

enum cycle_state { get_direction, wait_for_user_input, decision }
var current_cycle_state = cycle_state.get_direction

var has_acquired_direction_for_this_cycle = false
var has_user_input_for_this_cycle = false

func _ready():
	pass

func _process(_delta):
	inputControl()
	if (has_acquired_direction_for_this_cycle == false):
		direction_needed = get_direction()
		print("Direction Needed: " + direction_needed)
		has_user_input_for_this_cycle = false
		has_acquired_direction_for_this_cycle = true
	if (has_user_input_for_this_cycle == false):
		# User's answer is correct
		if ((Input.is_action_just_pressed("game_action_left") and direction_needed == "Left") or (Input.is_action_just_pressed("game_action_right") and direction_needed == "Right")):
			print_rich ("[color=green]Correct!\n")
			has_acquired_direction_for_this_cycle = false # gets a new randomized direction
			has_user_input_for_this_cycle = true 
		# User's answer is wrong
		elif ((Input.is_action_just_pressed("game_action_left") and direction_needed == "Right") or (Input.is_action_just_pressed("game_action_right") and direction_needed == "Left")):
			print_rich ("[color=red]Wrong! Answer again.")
			#has_acquired_direction_for_this_cycle = false # absence of these assignments stops the cycle from getting a new randomized direction
			#has_user_input_for_this_cycle = true

func get_direction(): # Picks a random direction (left or right) whenver this function is called
	return direction[randi() % direction.size()]

func inputControl():
	# This is used to detect input, mainly for debugging purposes langs
	if Input.is_action_just_pressed("game_action_left"):
		print("User Entered: Left")
	if Input.is_action_just_pressed("game_action_right"):
		print("User Entered: Right")
