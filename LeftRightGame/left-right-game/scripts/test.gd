extends Control

@onready var game_timer = $GameTimer

enum game_state { game_start, game_in_progress, game_finished }
var currentState = game_state.game_start

var direction = ["Left", "Right"]
var direction_needed

enum cycle_state { get_direction, wait_for_user_input, decision }
var current_cycle_state = cycle_state.get_direction

var initiating_new_round = true
var round = 1
var required_right_answers = 10
var current_right_answers = 0

var has_acquired_direction_for_this_cycle = false
var has_user_input_for_this_cycle = false



func _ready():
	pass
	game_timer.start()

func _process(_delta):
	match current_cycle_state:
		cycle_state.get_direction:
			check_round_progress()
			direction_needed = get_direction()
			print(direction_needed)
			current_cycle_state = cycle_state.wait_for_user_input # move to the next cycle state
		cycle_state.wait_for_user_input:
			# User's answer is correct
			if ((Input.is_action_just_pressed("game_action_left") and direction_needed == "Left") or (Input.is_action_just_pressed("game_action_right") and direction_needed == "Right")):
				print_rich ("[color=green]Correct!\n")
				current_cycle_state = cycle_state.get_direction # move back to the previous cycle state
				current_right_answers += 1
			# User's answer is wrong
			elif ((Input.is_action_just_pressed("game_action_left") and direction_needed == "Right") or (Input.is_action_just_pressed("game_action_right") and direction_needed == "Left")):
				print_rich ("[color=red]Wrong! Answer again.")


func get_direction(): # Picks a random direction (left or right) whenver this function is called
	return direction[randi() % direction.size()]

func check_round_progress():
	if (current_right_answers >= required_right_answers):
		initiating_new_round = true
		print("Round Complete!")
	else:
		print("Round: " + str(round))
		print("In progress: " + str(current_right_answers) + "/" + str(required_right_answers))

func input_control():
	# This is used to detect input, mainly for debugging purposes langs
	#if Input.is_action_just_pressed("game_action_left"):
		#print("User Entered: Left")
	#if Input.is_action_just_pressed("game_action_right"):
		#print("User Entered: Right")
	pass

func _on_game_timer_timeout() -> void:
	#print("TIME IS UP")
	pass
