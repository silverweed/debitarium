extends Control

const LINE_THEME = preload("res://LineEditTheme.tres")

var dude_n = 0

func _ready():
	pass


func _on_PeopleButton_pressed():
	var input = preload("res://misc/RemovableInput.tscn").instance()
	$VBoxContainer/ScrollContainer/VBoxContainer/PeopleContainer.add_child(input)
	input.edit.theme = LINE_THEME
	input.edit.text = "UnnamedDude%d" % dude_n
	input.rect_min_size.y = $VBoxContainer/ScrollContainer/VBoxContainer/NameLabel.rect_min_size.y
	input.button.rect_min_size.x = input.rect_min_size.y
	dude_n += 1
