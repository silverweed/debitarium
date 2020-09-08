class_name DebitariumListEntry
extends Control

var person: Data.Person setget set_person

onready var name_label = $Panel/HBoxContainer/Name
onready var balance_label = $Panel/HBoxContainer/Balance

func _ready():
	pass
	
	
func set_person(p: Data.Person):
	person = p
	name_label.text = p.name
	calc_balance()
	

func calc_balance():
	var balance = Data.Cash.from_cents(person.balance.calc_balance())
	balance_label.text = balance.to_str()
	balance_label.modulate = balance.get_color()


func _on_Panel_pressed():
	var list = preload("res://screens/PersonTransactionList.tscn").instance()
	get_node("/root").add_child(list)
	list.set_person(person)
	list.connect("balance_changed", self, "calc_balance")
