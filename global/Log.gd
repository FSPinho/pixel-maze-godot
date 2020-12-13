extends Node


func i(message="", deep=1):
	while deep > 0:
		message = "--- " + message
		deep -= 1
	print(" ", message)
