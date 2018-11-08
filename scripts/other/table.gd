extends Control


onready var records = [
	$table/table_row,
	$table/table_row2,
	$table/table_row3,
	$table/table_row4,
	$table/table_row5
]


func _ready():
	for i in range(game.records.size()):
		records[i].set_data(game.records[i])
