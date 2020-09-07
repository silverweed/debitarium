class_name DebitariumListEntry
extends Control

var person: Data.Person setget set_person

onready var name_label = $HBoxContainer/Name
onready var balance_label = $HBoxContainer/Balance

func _ready():
	pass
	
	
func set_person(p: Data.Person):
	name_label.text = p.name
	balance_label.text = p.balance.calc_balance().to_str()
