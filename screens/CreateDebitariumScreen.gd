extends Control

const LINE_THEME = preload("res://LineEditTheme.tres")

var dude_n = 0

func _ready():
	pass


func get_debitarium_name():
	return $VBoxContainer/ScrollContainer/VBoxContainer/NameInput.text
	

func get_people():
	var names = []
	for ch in $VBoxContainer/ScrollContainer/VBoxContainer/PeopleContainer.get_children():
		names.append(ch.edit.text)
	return names
	

func make_debitarium() -> Array:
	var db_name = get_debitarium_name()
	if db_name == null:
		return [null, "Name cannot be empty"]

	var people = get_people()
	if len(people) == 0:
		return [null, "Must have at least 1 person"]
		
	var p = people.duplicate()
	p.sort()
	for i in range(1, len(p)):
		if p[i-1] == p[i]:
			return [null, "Cannot have multiple people with the same name"]
			
	var dbt = Data.Debitarium.new(db_name, people)
	return [dbt, null]
	
func _on_PeopleButton_pressed():
	var input: RemovableInput = preload("res://misc/RemovableInput.tscn").instance()
	$VBoxContainer/ScrollContainer/VBoxContainer/PeopleContainer.add_child(input)
	input.edit.theme = LINE_THEME
	input.edit.text = "UnnamedDude%d" % dude_n
	input.rect_min_size.y = $VBoxContainer/ScrollContainer/VBoxContainer/NameLabel.rect_min_size.y
	input.button.rect_min_size.x = input.rect_min_size.y
	dude_n += 1


func _on_Yes_pressed():
	get_tree().change_scene("res://screens/DebitariumListScreen.tscn")


func _on_No_pressed():
	$PopupPanel.hide()


func _on_DoneButton_pressed():
	$PopupPanel.show()
	var dbt = make_debitarium()
	if dbt[1] != null:
		$PopupPanel/VBoxContainer/PopupTitle.text = "ERROR"
		$PopupPanel/VBoxContainer/HBoxContainer/Yes.hide()
		$PopupPanel/VBoxContainer/HBoxContainer/No.hide()
		$PopupPanel/VBoxContainer/HBoxContainer/OK.show()
		$PopupPanel/VBoxContainer/Recap.text = dbt[1]
	else:
		$PopupPanel/VBoxContainer/PopupTitle.text = "Create this debitarium?"
		$PopupPanel/VBoxContainer/HBoxContainer/Yes.show()
		$PopupPanel/VBoxContainer/HBoxContainer/No.show()
		$PopupPanel/VBoxContainer/HBoxContainer/OK.hide()
		dbt = dbt[0]
		gDataManager.debitarium = dbt
		var recap = dbt.name + "\n\n"
		for person in dbt.people:
			recap += " - " + person.name + "\n"
		$PopupPanel/VBoxContainer/Recap.text = recap
