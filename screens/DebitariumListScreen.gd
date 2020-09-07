extends Control

func _ready():
	var dbt: Data.Debitarium = gDataManager.debitarium
	assert(dbt != null)
	$VBoxContainer/DebitariumName.text = dbt.name
	
	for person in dbt.people:
		var entry = preload("res://misc/DebitariumListEntry.tscn").instance()
		$VBoxContainer/ScrollContainer/People.add_child(entry)
		entry.person = person
	
