extends Control

signal balance_changed

var person: Data.Person setget set_person

onready var transaction_list = $VBoxContainer/ScrollContainer/TransactionList
onready var cash_label = $VBoxContainer/Total/CashLabel

func set_person(_person: Data.Person):
	person = _person
	
	$VBoxContainer/HBoxContainer/PersonName.text = person.name
	
	for t in person.balance.transactions:
		assert(t is Data.Transaction and t != null)
		var entry = preload("res://misc/RemovableLabel.tscn").instance()
		transaction_list.add_child(entry)
		entry.disconnect_signals()
		entry.button.connect("pressed", self, "on_entry_pressed", [entry, t])
		entry.left_label.text = t.description
		entry.right_label.text = t.cash.to_str()
		entry.right_label.modulate = t.cash.get_color()
	
	calc_total()
	

func calc_total():
	var total = Data.Cash.from_cents(person.balance.calc_balance())
	cash_label.text = total.to_str()
	cash_label.modulate = total.get_color()
	print(JSON.print(gDataManager.debitarium.serialize()))


func _on_ExitButton_pressed():
	queue_free()


func on_entry_pressed(entry: Control, t: Data.Transaction):
	# TODO ask for confirmation!
	person.balance.remove_transaction(t)
	entry.queue_free()
	calc_total()
	emit_signal("balance_changed")
