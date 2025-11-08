extends Control

onready var handler = preload("res://scripts/input_handler.gd").new()

# onready var inputs: InputHandler = get_node("../../Inputs")
var remap_key = "Space"
var remapping

func show_menu():
	# label

	# create the buttons for each action 
	for action in handler.Action:
		var action_label = handler.Action[action] 
		var action_name = handler._get_name(handler.Action[action])
		# $"VBoxContainer/Buttons".add_child()
		# _show_main_buttons(new_game_button)

func _input(event):
	if event.as_text() == remap_key:
		remapping = true
		print("now remapping...")
		return

	if not remapping: return
	else: remapping = false

	# action from whichever button has focus

	InputMap.action_add_event("action_jump_p1", event)
	print("key %s selected" % event.as_text())

