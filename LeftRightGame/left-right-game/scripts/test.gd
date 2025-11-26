extends Control

@onready var game_timer = $GameTimer
@onready var penalty_timer = $PenaltyTimer
@onready var ready_timer = $ReadyTimer

# 1 - Game
enum game_state { game_start, game_in_progress, game_finished }
var current_game_state = game_state.game_start
# 2 - Rounds
enum round_state { ready, running }
var current_round_state = round_state.ready
# 3 - Cycle
enum cycle_state { get_direction, wait_for_user_input }
var current_cycle_state = cycle_state.get_direction
var penalty_is_active = false

var direction = ["Left", "Right"]
var direction_needed

var round = 1
var required_right_answers = 10
var current_right_answers = 0

func _ready():
	pass
	game_timer.start()

func get_direction(): # Picks a random direction (left or right) whenever this function is called
	return direction[randi() % direction.size()]

func _process(_delta):
	match current_round_state:
		round_state.ready:
			print("Round " + str(round))
			print("Ready...")
			ready_timer.start()
			current_round_state = null # Stop the current state from looping and let ready timer do its thing
		round_state.running: # Within this state, there are two more sub-states:
			match current_cycle_state:
				cycle_state.get_direction:
					check_round_progress()
					if (current_round_state == round_state.running): # Do not re-run the cycle unless the round state is set to running
						direction_needed = get_direction()
						print(direction_needed)
						current_cycle_state = cycle_state.wait_for_user_input # To the next cycle state
				cycle_state.wait_for_user_input:
					if (penalty_is_active == false):
						# User's answer is correct
						if ((Input.is_action_just_pressed("game_action_left") and direction_needed == "Left") or (Input.is_action_just_pressed("game_action_right") and direction_needed == "Right")):
							print_rich ("[color=green]Correct!\n")
							current_cycle_state = cycle_state.get_direction # Back to the previous cycle state
							current_right_answers += 1
						# User's answer is wrong
						elif ((Input.is_action_just_pressed("game_action_left") and direction_needed == "Right") or (Input.is_action_just_pressed("game_action_right") and direction_needed == "Left")):
							print_rich ("[color=red]Wrong! Answer again.")
							penalty_is_active = true
							penalty_timer.start()

func check_round_progress():
	if (current_right_answers >= required_right_answers):
		print("Round Complete!\n")
		round += 1
		current_right_answers = 0
		current_round_state = round_state.ready
	else:
		# print("Round: " + str(round))
		print("In progress: " + str(current_right_answers) + "/" + str(required_right_answers))

func _on_game_timer_timeout() -> void:
	#print("TIME IS UP")
	pass

func _on_penalty_timer_timeout() -> void:
	penalty_is_active = false # Remove the penalty after the timer

func _on_ready_timer_timeout() -> void:
	current_round_state = round_state.running
	print("Go!\n")

func input_control():
	# This is used to detect input, mainly for debugging purposes langs
	#if Input.is_action_just_pressed("game_action_left"):
		#print("User Entered: Left")
	#if Input.is_action_just_pressed("game_action_right"):
		#print("User Entered: Right")
	pass
