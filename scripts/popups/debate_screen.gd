extends "popup.gd"


var back_button = true
var token_index


func open(_token_index):
	token_index = _token_index
	print("EXCUSA: ", token_index)
	.open("open_debate")


func close():
	.close("close_debate")
